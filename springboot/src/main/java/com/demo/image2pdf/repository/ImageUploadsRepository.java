package com.demo.image2pdf.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.demo.image2pdf.entity.ImageUploads;
import com.demo.image2pdf.entity.User;

@Repository
public interface ImageUploadsRepository extends JpaRepository<ImageUploads, Integer> {

	ImageUploads findByImageUploadId(Integer imageUploadId);

	ImageUploads findByUserId(User user);

	ImageUploads findByS3ObjectKey(Integer s3ObjectKey);
	
	ImageUploads findByS3ObjectKeyAndIsPdfGenerated(String s3ObjectKey, Boolean isPdfGenerated);
}
