FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/image2pdfconverter-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} image2pdfconverter-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/image2pdfconverter-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080