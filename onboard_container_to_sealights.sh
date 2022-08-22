#!/bin/sh
#
# Onboard a pre-built application that has been deployed via container to SeaLights

# Application image: repo, name, tag
export DOCKER_REPO="dwaynedreakford"
export IMAGE_NAME="calculator_rest_container"
export IMAGE_TAG="2.0"
export IMAGE_SPEC="$DOCKER_REPO/$IMAGE_NAME:$IMAGE_TAG"

# Download the SeaLights Java agent
cd $PROJECT_ROOT_DIR
rm -rf sealights && mkdir sealights
wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip && \
    unzip -o -d sealights sealights-java-latest.zip

# Add the agent token
cp $AGENT_TOKEN_FILE sealights/
rm sealights-java-latest.zip

# Build the image
# For simplicity, the SL Java Agent is added to the image
docker build -t $IMAGE_SPEC .

# Scan and report the app structure to SeaLights
export SERVICE_NAME=$IMAGE_NAME

# Start the container
# The entry point to scans and starts the application
docker run --name $SERVICE_NAME -d -p 8091:8091 $IMAGE_SPEC 

# Manual tests
#
# Start the app with the test listener attached as a java agent.
# Report the tests via the Chrome plugin or SL UI.

