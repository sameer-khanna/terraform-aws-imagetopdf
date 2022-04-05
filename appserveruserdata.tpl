#!/bin/bash -xe

sudo bash


cat << 'EOF' >/tmp/db.setup

use imagetopdf;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email_id` varchar(45) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `image_uploads` (
  `image_upload_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `s3_object_key` varchar(63) NOT NULL,
  `is_pdf_generated` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`image_upload_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `image_uploads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `generated_pdf` (
  `generated_pdf_id` int NOT NULL AUTO_INCREMENT,
  `image_upload_id` int NOT NULL,
  `s3_object_key` varchar(63) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`generated_pdf_id`),
  KEY `image_upload_id` (`image_upload_id`),
  CONSTRAINT `generated_pdf_ibfk_1` FOREIGN KEY (`image_upload_id`) REFERENCES `image_uploads` (`image_upload_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


EOF

mysql -u "${rds_username}" -p"${rds_password}" -h "${rds_endpoint}" < /tmp/db.setup

rm -f /tmp/db.setup

cd /var
mkdir api
cd api
mkdir springboot
cd springboot
mkdir image-temp
mkdir pdf-temp
mkdir config

aws s3 cp s3://app-deployables-us/image2pdfconverter-0.0.1-SNAPSHOT.jar /var/api/springboot
aws s3 cp s3://app-deployables-us/application.properties /var/api/springboot/config

cd ../
chmod 0775 -R springboot
cd springboot

java -jar image2pdfconverter-0.0.1-SNAPSHOT.jar