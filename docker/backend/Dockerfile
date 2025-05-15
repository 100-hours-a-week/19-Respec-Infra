# 빌드 단계
FROM eclipse-temurin:21-jdk-alpine as builder

WORKDIR /app

COPY . .

RUN ./gradlew build -x test

# 런 단계
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar spec-ranking-0.0.1-SNAPSHOT.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "spec-ranking-0.0.1-SNAPSHOT.jar"]
