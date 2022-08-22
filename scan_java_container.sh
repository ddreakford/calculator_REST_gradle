#!/bin/sh
#

# Ensure there are no conflicts with what other VMs may
# need from JAVA_TOOL_OPTIONS by stashing, clearing, and
# then replacing its value after we're done here.
SAVE_JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS}"
JAVA_TOOL_OPTIONS=

# Report the build to SeaLights
java -Dsl.ignoreCertificateErrors=true -jar ${LIBS_DIR}/sealights/sl-build-scanner.jar -config \
    -tokenfile ${LIBS_DIR}/sealights/sltoken-dev-cs.txt \
    -appname "${APP_NAME}" \
    -branchname "main" \
    -buildname "2.$(date +%Y-%m-%d-%H-%M-%S)" \
    -pi "*${PACKAGE_PREFIX}.*" \
    -buildsessionidfile ${LIBS_DIR}/sealights/buildSessionId.txt

# Scan the application
java -Dsl.ignoreCertificateErrors=true  -jar ${LIBS_DIR}/sealights/sl-build-scanner.jar -scan \
    -tokenfile ${LIBS_DIR}/sealights/sltoken-dev-cs.txt \
    -buildsessionidfile ${LIBS_DIR}/sealights/buildSessionId.txt \
    -workspacepath "${LIBS_DIR}/" -r -fi "*.jar,*.war" -fe "*sl-*.jar"                

# Start the application with the test listener
java -jar -javaagent:${LIBS_DIR}/sealights/sl-test-listener.jar \
    -Dsl.tokenFile=${LIBS_DIR}/sealights/sltoken-dev-cs.txt \
    -Dsl.buildSessionIdFile=${LIBS_DIR}/sealights/buildSessionId.txt \
    -Dsl.labId=calculator-dev-laptop \
    -Dsl.log.level=info \
    -Dsl.log.toConsole=true \
    -Dsl.log.toFile=true -Dsl.log.folder=${LIBS_DIR}/sealights \
    ${LIBS_DIR}/rest-calculator-0.0.1-SNAPSHOT.jar \
    com.slsamples.gradle.java.springboot.Application

JAVA_TOOL_OPTIONS="${SAVE_JAVA_TOOL_OPTIONS}"