FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn package


FROM amazoncorretto:17 AS final
WORKDIR /app
COPY --from=build /app/target/*.jar /app/main.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/main.jar"]