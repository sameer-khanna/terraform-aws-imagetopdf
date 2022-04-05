package com.demo.image2pdf.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.simplesystemsmanagement.AWSSimpleSystemsManagement;
import com.amazonaws.services.simplesystemsmanagement.AWSSimpleSystemsManagementClientBuilder;

@Configuration
public class BeanConfiguration {

	@Autowired
	private ApplicationProperties properties;

	@Bean(name = "s3Client")
	public AmazonS3 amazonS3Client() {
		Regions awsRegion = Regions.fromName(properties.getProperty("aws.region"));
		AmazonS3 s3 = AmazonS3ClientBuilder.standard().withRegion(awsRegion).build();
		return s3;
	}

	@Bean(name = "ssmClient")
	public AWSSimpleSystemsManagement ssmClient() {
		AWSSimpleSystemsManagement ssmClient = AWSSimpleSystemsManagementClientBuilder.standard()
				.withRegion(properties.getProperty("aws.region")).build();
		return ssmClient;
	}

}
