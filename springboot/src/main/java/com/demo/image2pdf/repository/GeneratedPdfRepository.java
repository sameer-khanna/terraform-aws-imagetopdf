package com.demo.image2pdf.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.demo.image2pdf.entity.GeneratedPdf;
import com.demo.image2pdf.entity.ImageUploads;

@Repository
public interface GeneratedPdfRepository extends JpaRepository<GeneratedPdf, Integer> {

	GeneratedPdf findByGeneratedPdfId(Integer generatedPdfId);

	GeneratedPdf findByImageUploadId(ImageUploads imageUploads);

	GeneratedPdf findByS3ObjectKey(Integer s3ObjectKey);

}
