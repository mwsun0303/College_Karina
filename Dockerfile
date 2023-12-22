
FROM amazoncorretto:17
ARG JAR_FILE=*-0.0.1-SNAPSHOT.jar

RUN mkdir -p /app
WORKDIR /app

COPY target/${JAR_FILE} /app/app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]

