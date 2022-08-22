
# Base image was created via this Dockerfile:
# https://github.com/oracle/docker-images/blob/main/OracleJava/8/Dockerfile
FROM        oracle/jdk:18

# Add application jar
ENV         LIBS_DIR="/usr/local/lib"
COPY        build/libs/rest-calculator-0.0.1-SNAPSHOT.jar ${LIBS_DIR}/
EXPOSE      8091

# Add sealights java agent and supporting script
COPY        sealights/* ${LIBS_DIR}/sealights/
COPY        scan_java_container.sh ${LIBS_DIR}/sealights/

# Set variables used by the script to scan and start the app
ENV         APP_NAME="calculator_rest_container"
ENV         PACKAGE_PREFIX="com.slsamples.gradle.java.springboot"

# ENTRYPOINT ["java", "-jar", "/usr/local/lib/rest-calculator-0.0.1-SNAPSHOT.jar", "com.slsamples.gradle.java.springboot.Application"]
ENTRYPOINT ${LIBS_DIR}/sealights/scan_java_container.sh
