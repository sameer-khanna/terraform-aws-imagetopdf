package com.demo.image2pdf.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.demo.image2pdf.entity.GeneratedPdf;
import com.demo.image2pdf.entity.ImageUploads;
import com.demo.image2pdf.repository.GeneratedPdfRepository;
import com.demo.image2pdf.service.GeneratedPdfService;

@Service
public class GeneratedPdfServiceImpl implements GeneratedPdfService {

	@Autowired
	private GeneratedPdfRepository repository;

	@Override
	public GeneratedPdf findByGeneratedPdfId(Integer generatedPdfId) {
		return repository.findByGeneratedPdfId(generatedPdfId);
	}

	@Override
	public GeneratedPdf findByImageUploadId(ImageUploads imageUploads) {
		return repository.findByImageUploadId(imageUploads);
	}

	@Override
	public GeneratedPdf findByS3ObjectKey(Integer s3ObjectKey) {
		return repository.findByS3ObjectKey(s3ObjectKey);
	}

	@Override
	public GeneratedPdf save(GeneratedPdf generatedPdf) {
		return repository.save(generatedPdf);
	}

	@Override
	public void deleteById(Integer id) {
		repository.deleteById(id);
	}

}
