package com.demo.image2pdf.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.demo.image2pdf.entity.ImageUploads;
import com.demo.image2pdf.entity.User;
import com.demo.image2pdf.repository.ImageUploadsRepository;
import com.demo.image2pdf.service.ImageUploadsService;

@Service
public class ImageUploadsServiceImpl implements ImageUploadsService {

	@Autowired
	private ImageUploadsRepository repository;

	@Override
	public ImageUploads findByImageUploadId(Integer imageUploadId) {
		return repository.findByImageUploadId(imageUploadId);
	}

	@Override
	public ImageUploads findByUser(User user) {
		return repository.findByUserId(user);
	}

	@Override
	public ImageUploads findByS3ObjectKey(Integer s3ObjectKey) {
		return repository.findByS3ObjectKey(s3ObjectKey);
	}

	@Override
	public ImageUploads save(ImageUploads imageUploads) {
		return repository.save(imageUploads);
	}

	@Override
	public void deleteById(Integer id) {
		repository.deleteById(id);
	}

	@Override
	public ImageUploads findByS3ObjectKeyAndIsPdfGenerated(String s3ObjectKey, Boolean isPdfGenerated) {
		return repository.findByS3ObjectKeyAndIsPdfGenerated(s3ObjectKey, isPdfGenerated);
	}

}
