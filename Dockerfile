FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app
COPY .mvn/wrapper/maven-wrapper.jar .mvn/wrapper/maven-wrapper.jar
COPY .mvn/wrapper/maven-wrapper.properties .mvn/wrapper/maven-wrapper.properties
COPY mvnw ./
COPY mvnw.cmd ./
COPY pom.xml ./
COPY work ./work
RUN ./mvnw dependency:resolve

COPY src ./src

CMD ["./mvnw", "spring-boot:run"]