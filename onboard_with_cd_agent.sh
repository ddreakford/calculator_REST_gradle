#!/bin/sh

# Onboard the sample REST Calculator service to SeaLights
# using the CD Agent

# Pertinent environment variables
export PROJECT_ROOT_DIR=
export SL_AGENT_TOKEN_FILE=     # an Agent token
export SL_LAB_ID=               # an Integration Build Lab Id for CD Agent
export SL_COMPONENT_NAME=rest_calculator_main
export SL_COMPONENT_BUILD=$(date "+%Y.%m.%d-%H.%M.%S")

# Download the agent
cd $PROJECT_ROOT_DIR
rm -rf sl-cd-agent && mkdir sl-cd-agent
wget -nv  https://agents.sealights.co/sl-cd-agent/sl-cd-agent-latest.zip && \
    unzip -o -d sl-cd-agent sl-cd-agent-latest.zip
echo "Sealights CD Agent version used is:" `cat sl-cd-agent/version.txt`
rm sl-cd-agent-latest.zip

# Add the agent token
cp $SL_AGENT_TOKEN_FILE sl-cd-agent/

# Start the application with the SL CD Agent as javaagent
java -jar -javaagent:sl-cd-agent/sl-cd-agent.jar \
    -Dsl.tokenFile=sl-cd-agent/$SL_AGENT_TOKEN_FILE \
    -Dsl.appName=$SL_COMPONENT_NAME \
    -Dsl.buildName=$SL_COMPONENT_BUILD \
    -Dsl.labId=$SL_LAB_ID \
    -Dsl.includes='com.slsamples.gradle.java.springboot*' \
    -Dsl.log.level=info \
    -Dsl.log.toConsole=true \
    -Dsl.log.toFile=true -Dsl.log.folder=sl-cd-agent \
    build/libs/rest-calculator-0.2.0-SNAPSHOT.jar \
    com.slsamples.gradle.java.springboot.Application

