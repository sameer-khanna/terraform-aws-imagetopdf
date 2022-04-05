package com.demo.image2pdf.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.time.Clock;
import java.time.Instant;
import java.util.Date;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.simplesystemsmanagement.AWSSimpleSystemsManagement;
import com.amazonaws.services.simplesystemsmanagement.model.GetParameterRequest;
import com.amazonaws.services.simplesystemsmanagement.model.GetParameterResult;
import com.demo.image2pdf.configuration.ApplicationProperties;
import com.demo.image2pdf.entity.GeneratedPdf;
import com.demo.image2pdf.entity.ImageUploads;
import com.demo.image2pdf.entity.User;
import com.demo.image2pdf.service.GeneratedPdfService;
import com.demo.image2pdf.service.ImageUploadsService;
import com.demo.image2pdf.service.UserService;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfWriter;

@RestController
@CrossOrigin
public class Image2PdfController {

	@Autowired
	private AmazonS3 s3Client;

	@Autowired
	private AWSSimpleSystemsManagement ssmClient;

	@Autowired
	private ApplicationProperties properties;

	@Autowired
	private UserService userService;

	@Autowired
	private ImageUploadsService imageUploadsService;

	@Autowired
	private GeneratedPdfService generatedPdfService;
	
	private Logger logger = LoggerFactory.getLogger(Image2PdfController.class);

	@PostMapping("/uploadImage")
	public ResponseEntity<String> handleFileUpload(@RequestParam("file") MultipartFile multipartFile) {
		logger.debug("Inside uploadImage method.");

		Clock clock = Clock.systemDefaultZone();
		long milliSeconds = clock.millis();

		String s3ObjectKey = milliSeconds + "-" + multipartFile.getOriginalFilename();
		File file = new File(properties.getProperty("image.temp.location") + s3ObjectKey);
		GetParameterResult paramResult = getSSMParamValue("ssm.s3bucketname");
		try {
			multipartFile.transferTo(file);
			s3Client.putObject(paramResult.getParameter().getValue(), s3ObjectKey, file);

			User user = new User();
			user.setEmailId("guestuser@sample.com");
			user.setFirstName("Guest");
			user.setLastName("User");

			ImageUploads imageUploads = new ImageUploads();
			imageUploads.setIsActive(true);
			imageUploads.setIsPdfGenerated(false);
			imageUploads.setS3ObjectKey(s3ObjectKey);
			imageUploads.setUserId(user);

			GeneratedPdf generatedPdf = new GeneratedPdf();
			generatedPdf.setImageUploadId(imageUploads);
			generatedPdf.setIsActive(true);
			generatedPdf.setS3ObjectKey(s3ObjectKey);

			userService.save(user);
			imageUploadsService.save(imageUploads);
			generatedPdfService.save(generatedPdf);

		} catch (IllegalStateException | IOException e) {
			logger.error("Error while uploading the PDF.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Error while uploading the PDF.");
		}
		logger.debug("Exiting uploadImage method.");
		return ResponseEntity.status(HttpStatus.OK).body(s3ObjectKey);
	}

	@PostMapping("/generatePdf")
	public ResponseEntity<String> generatePdf(@RequestParam String imageName) {
		logger.debug("Inside generatePdf method.");

		ImageUploads imageUploads = imageUploadsService.findByS3ObjectKeyAndIsPdfGenerated(imageName, false);

		if (imageUploads == null) {
			logger.error("Image not found. imageUploads is null.");
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Image not found");
		}
		GetParameterResult paramResult = getSSMParamValue("ssm.s3bucketname");

		S3Object s3object = s3Client.getObject(paramResult.getParameter().getValue(), imageUploads.getS3ObjectKey());
		if (s3object == null) {
			logger.error("Image not found. s3object is null.");
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Image not found");
		}
		S3ObjectInputStream inputStream = s3object.getObjectContent();
		File file = new File(properties.getProperty("image.temp.location") + imageUploads.getS3ObjectKey());

		try (OutputStream outputStream = new FileOutputStream(file)) {
			IOUtils.copy(inputStream, outputStream);
		} catch (FileNotFoundException e) {
			logger.error("Error while generating the PDF.", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Error while generating the PDF.");
		} catch (IOException e) {
			logger.error("Error while generating the PDF.", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Error while generating the PDF.");
		}

		String output = imageProcessing(imageUploads, file);

		File pdf = new File(output);

		s3Client.putObject(paramResult.getParameter().getValue(), "pdf/" + pdf.getName(), new File(output));
		Date expiration = presignedUrlExpiration();

		GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(
				paramResult.getParameter().getValue(), "pdf/" + pdf.getName()).withMethod(HttpMethod.GET)
						.withExpiration(expiration);
		URL url = s3Client.generatePresignedUrl(generatePresignedUrlRequest);

		if (url == null) {
			logger.error("Image not found. url is null.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Error while generating the PDF download URL.");
		}

		imageUploads.setIsPdfGenerated(true);
		imageUploadsService.save(imageUploads);
		
		logger.debug("Exiting generatePdf method.");
		return ResponseEntity.status(HttpStatus.OK).body(url.toString());
	}

	private static Date presignedUrlExpiration() {
		Date expiration = new Date();
		long expTimeMillis = Instant.now().toEpochMilli();
		expTimeMillis += 1000 * 60 * 5;
		expiration.setTime(expTimeMillis);
		return expiration;
	}

	private String imageProcessing(ImageUploads imageUploads, File file) {
		Document document = new Document();
		String input = file.getAbsolutePath();
		int index = imageUploads.getS3ObjectKey().lastIndexOf(".");
		String pdfName = imageUploads.getS3ObjectKey().substring(0, index);
		
		String output = properties.getProperty("pdf.temp.location") + pdfName + ".pdf";
		FileOutputStream fos;
		try {
			fos = new FileOutputStream(output);

			PdfWriter writer = PdfWriter.getInstance(document, fos);
			writer.open();
			document.open();
			Image image = Image.getInstance(input);
			int indentation = 0;

			float scaler = ((document.getPageSize().getWidth() - document.leftMargin()
			               - document.rightMargin() - indentation) / image.getWidth()) * 100;

			image.scalePercent(scaler);
			document.add(Image.getInstance(image));
			document.close();
			writer.close();
		} catch (IOException | DocumentException e) {
			logger.error("Error during image processing.",e);
		}
		return output;
	}

	private GetParameterResult getSSMParamValue(String key) {
		GetParameterRequest paramRequest = new GetParameterRequest();
		paramRequest.withName(properties.getProperty(key)).setWithDecryption(true);
		GetParameterResult paramResult = new GetParameterResult();
		paramResult = ssmClient.getParameter(paramRequest);
		return paramResult;
	}

}
