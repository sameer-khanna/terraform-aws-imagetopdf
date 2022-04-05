package com.demo.image2pdf.service;

import com.demo.image2pdf.entity.ImageUploads;
import com.demo.image2pdf.entity.User;

public interface ImageUploadsService {

	ImageUploads findByImageUploadId(Integer imageUploadId);

	ImageUploads findByUser(User user);

	ImageUploads findByS3ObjectKey(Integer s3ObjectKey);
	
	ImageUploads save(ImageUploads imageUploads);
	
	void deleteById(Integer id);
	
	ImageUploads findByS3ObjectKeyAndIsPdfGenerated(String s3ObjectKey, Boolean isPdfGenerated);
	
}
