# Stage 1: Build using Maven
FROM maven:3.8.7-eclipse-temurin-17 as builder

WORKDIR /app

# Copy source code and build the app
COPY . .

RUN mvn clean package 

# Stage 2: Run using OpenJDK
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy the jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]


