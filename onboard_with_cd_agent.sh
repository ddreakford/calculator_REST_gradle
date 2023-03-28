#!/bin/sh

# Onboard the sample REST Calculator service to SeaLights
# using the CD Agent

# Download the agent
cd $PROJECT_ROOT_DIR
rm -rf sl-cd-agent && mkdir sl-cd-agent
wget -nv  https://agents.sealights.co/sl-cd-agent/sl-cd-agent-latest.zip && \
    unzip -o -d sl-cd-agent sl-cd-agent-latest.zip
echo "Sealights CD Agent version used is:" `cat sl-cd-agent/version.txt`
rm sl-cd-agent-latest.zip

# Add the agent token
cp $AGENT_TOKEN_FILE sl-cd-agent/

# Start the application with the SL CD Agent as javaagent
java -jar -javaagent:sl-cd-agent/sl-cd-agent.jar \
    -Dsl.tokenFile=sl-cd-agent/$AGENT_TOKEN_FILE \
    -Dsl.appName=Calculator-REST-CDAgent \
    -Dsl.buildName=0.2.0 \
    -Dsl.includes='com.slsamples.gradle.java.springboot*' \
    -Dsl.labId=integ_main_fb68_CalculatorRESTCDAgent \
    -Dsl.log.level=info \
    -Dsl.log.toConsole=true \
    -Dsl.log.toFile=true -Dsl.log.folder=sl-cd-agent \
    build/libs/rest-calculator-0.2.0-SNAPSHOT.jar \
    com.slsamples.gradle.java.springboot.Application

