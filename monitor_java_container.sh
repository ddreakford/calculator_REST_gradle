#!/bin/sh

# Ensure there are no conflicts with what other VMs may
# need from JAVA_TOOL_OPTIONS by stashing, clearing, and
# then replacing its value after we're done here.
SAVE_JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS}"
JAVA_TOOL_OPTIONS=

# Start the application with the test listener
java -jar -javaagent:${LIBS_DIR}/sealights/sl-test-listener.jar \
    -Dsl.tokenFile=${LIBS_DIR}/sealights/sltoken.txt \
    -Dsl.buildSessionIdFile=${LIBS_DIR}/sealights/buildSessionId.txt \
    -Dsl.labId=calculator-dev-laptop \
    -Dsl.log.level=info \
    -Dsl.log.toConsole=false \
    -Dsl.log.toFile=true -Dsl.log.folder=${LIBS_DIR}/sealights \
    ${LIBS_DIR}/rest-calculator-0.2.0-SNAPSHOT.jar \
    com.slsamples.gradle.java.springboot.Application

JAVA_TOOL_OPTIONS="${SAVE_JAVA_TOOL_OPTIONS}"