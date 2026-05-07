# 使用 JDK 21 的运行时镜像
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# 复制 Maven 打包好的 jar
COPY target/demo-1.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
