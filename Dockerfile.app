# Create REST Calculator image

# Base image was created via this Dockerfile:
# https://github.com/oracle/docker-images/blob/main/OracleJava/8/Dockerfile
FROM        oracle/jdk:18

# Add application jar
ENV         LIBS_DIR="/usr/local/lib"
COPY        build/libs/rest-calculator-0.0.1-SNAPSHOT.jar ${LIBS_DIR}/
EXPOSE      8091

ENTRYPOINT ["java", "-jar", "/usr/local/lib/rest-calculator-0.0.1-SNAPSHOT.jar", "com.slsamples.gradle.java.springboot.Application"]
