package com.demo.image2pdf.service;

import com.demo.image2pdf.entity.GeneratedPdf;
import com.demo.image2pdf.entity.ImageUploads;

public interface GeneratedPdfService {
	
	GeneratedPdf findByGeneratedPdfId(Integer generatedPdfId);

	GeneratedPdf findByImageUploadId(ImageUploads imageUploads);

	GeneratedPdf findByS3ObjectKey(Integer s3ObjectKey);
	
	GeneratedPdf save(GeneratedPdf generatedPdf);
	
	void deleteById(Integer id);

}
