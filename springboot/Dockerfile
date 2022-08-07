FROM openjdk:8-jdk-alpine
RUN mkdir var
RUN WORKDIR var
RUN mkdir api
RUN WORKDIR api
RUN mkdir springboot
RUN WORKDIR springboot
RUN mkdir image-temp
RUN mkdir pdf-temp
ARG JAR_FILE=target/image2pdfconverter-0.0.1-SNAPSHOT.jar
ARG CONFIG_FILE=src/main/resources/application.properties
COPY ${JAR_FILE} image2pdfconverter-0.0.1-SNAPSHOT.jar
COPY ${CONFIG_FILE} config/application.properties
ENTRYPOINT ["java","-jar","/image2pdfconverter-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080