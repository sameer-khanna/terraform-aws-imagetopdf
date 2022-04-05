package com.demo.image2pdf.entity;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "image_uploads")
public class ImageUploads {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "image_upload_id")
	private Integer imageUploadId;

	@ManyToOne
	@JoinColumn(name = "user_id")
	private User userId;

	@OneToOne(mappedBy = "imageUploadId", cascade = CascadeType.ALL)
	private GeneratedPdf generatedPdf;

	@Column(name = "s3_object_key")
	private String s3ObjectKey;

	@Column(name = "is_pdf_generated")
	private Boolean isPdfGenerated;

	@Column(name = "is_active")
	private Boolean isActive;

	public Integer getImageUploadId() {
		return imageUploadId;
	}

	public void setImageUploadId(Integer imageUploadId) {
		this.imageUploadId = imageUploadId;
	}

	public User getUserId() {
		return userId;
	}

	public void setUserId(User userId) {
		this.userId = userId;
	}

	public String getS3ObjectKey() {
		return s3ObjectKey;
	}

	public void setS3ObjectKey(String s3ObjectKey) {
		this.s3ObjectKey = s3ObjectKey;
	}

	public Boolean getIsPdfGenerated() {
		return isPdfGenerated;
	}

	public void setIsPdfGenerated(Boolean isPdfGenerated) {
		this.isPdfGenerated = isPdfGenerated;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public GeneratedPdf getGeneratedPdf() {
		return generatedPdf;
	}

	public void setGeneratedPdf(GeneratedPdf generatedPdf) {
		this.generatedPdf = generatedPdf;
	}
}
