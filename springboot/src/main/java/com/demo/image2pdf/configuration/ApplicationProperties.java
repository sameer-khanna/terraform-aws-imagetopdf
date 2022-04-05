package com.demo.image2pdf.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

@Configuration
@PropertySource("file:config/application.properties")
public class ApplicationProperties {

	@Autowired
	private Environment env;

	public String getProperty(String key) {
		return env.getProperty(key);
	}

}
