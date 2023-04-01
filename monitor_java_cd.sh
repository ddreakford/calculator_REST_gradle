#!/bin/sh

# Ensure there are no conflicts with what other VMs may
# need from JAVA_TOOL_OPTIONS by stashing, clearing, and
# then replacing its value after we're done here.
SAVE_JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS}"
JAVA_TOOL_OPTIONS=

# Scan and monitor the app on deployment
java -jar -javaagent:$LIBS_DIR/sl-cd-agent/sl-cd-agent.jar \
    -Dsl.tokenFile=$LIBS_DIR/sl-cd-agent/sltoken.txt \
    -Dsl.appName=$SL_COMPONENT_NAME \
    -Dsl.buildName=$SL_COMPONENT_BUILD \
    -Dsl.labId=$SL_LAB_ID \
    -Dsl.includes="com.slsamples.gradle.java.springboot*" \
    -Dsl.log.level=info \
    -Dsl.log.toConsole=true \
    -Dsl.log.toFile=true -Dsl.log.folder=sl-cd-agent \
    $LIBS_DIR/rest-calculator-0.2.0-SNAPSHOT.jar \
    com.slsamples.gradle.java.springboot.Application

JAVA_TOOL_OPTIONS="${SAVE_JAVA_TOOL_OPTIONS}"