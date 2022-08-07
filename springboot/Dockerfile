FROM openjdk:8-jdk-alpine
RUN MKDIR var
RUN WORKDIR var
RUN MKDIR api
RUN WORKDIR api
RUN MKDIR springboot
RUN WORKDIR springboot
RUN MKDIR image-temp
RUN MKDIR pdf-temp
ARG JAR_FILE=target/image2pdfconverter-0.0.1-SNAPSHOT.jar
ARG CONFIG_FILE=src/main/resources/application.properties
COPY ${JAR_FILE} image2pdfconverter-0.0.1-SNAPSHOT.jar
COPY ${CONFIG_FILE} config/application.properties
ENTRYPOINT ["java","-jar","/image2pdfconverter-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080