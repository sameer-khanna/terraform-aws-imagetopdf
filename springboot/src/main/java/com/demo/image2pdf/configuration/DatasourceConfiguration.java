package com.demo.image2pdf.configuration;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DatasourceConfiguration {
	
	@Autowired
	private ApplicationProperties properties;

	@Bean
	public DataSource getDataSource() {
		DataSourceBuilder dataSourceBuilder = DataSourceBuilder.create();
		dataSourceBuilder.url(properties.getProperty("jdbc.url"));
		dataSourceBuilder.username(properties.getProperty("db.username"));
		dataSourceBuilder.password(properties.getProperty("db.password"));
		return dataSourceBuilder.build();
	}

}
