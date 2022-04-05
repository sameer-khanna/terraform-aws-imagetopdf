package com.demo.image2pdf.entity;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "generated_pdf")
public class GeneratedPdf {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "generated_pdf_id")
	private Integer generatedPdfId;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "image_upload_id", referencedColumnName = "image_upload_id")
	private ImageUploads imageUploadId;

	@Column(name = "s3_object_key")
	private String s3ObjectKey;

	@Column(name = "is_active")
	private Boolean isActive;

	public Integer getGeneratedPdfId() {
		return generatedPdfId;
	}

	public void setGeneratedPdfId(Integer generatedPdfId) {
		this.generatedPdfId = generatedPdfId;
	}

	public ImageUploads getImageUploadId() {
		return imageUploadId;
	}

	public void setImageUploadId(ImageUploads imageUploadId) {
		this.imageUploadId = imageUploadId;
	}

	public String getS3ObjectKey() {
		return s3ObjectKey;
	}

	public void setS3ObjectKey(String s3ObjectKey) {
		this.s3ObjectKey = s3ObjectKey;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

}
