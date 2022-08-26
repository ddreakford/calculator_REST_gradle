#!/bin/sh
#
# Onboard a pre-built application that has been deployed via container to SeaLights

# Application image: repo, name, tag
export DOCKER_REPO="dwaynedreakford"
export APP_IMAGE_NAME="calculator_rest"
export IMAGE_TAG="2.0"
export APP_IMAGE_SPEC="$DOCKER_REPO/$APP_IMAGE_NAME:$IMAGE_TAG"

# Download the SeaLights Java agent
cd $PROJECT_ROOT_DIR
rm -rf sealights && mkdir sealights
wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip && \
    unzip -o -d sealights sealights-java-latest.zip
rm sealights-java-latest.zip

# Add the agent token
cp $AGENT_TOKEN_FILE sealights/

# Build the app image
# For simplicity, the SL Java Agent is added to the image
docker build -f Dockerfile.app -t $APP_IMAGE_SPEC .
docker push $APP_IMAGE_SPEC

# Optional: Ensure the deployed app starts as expected
export APP_SERVICE_NAME="$APP_IMAGE_NAME"
docker run --name $APP_SERVICE_NAME -d -p 8091:8091 $APP_IMAGE_SPEC

# Create the testing environment with SeaLights monitoring
export TEST_IMAGE_SPEC="$APP_IMAGE_SPEC"-test
docker build -f Dockerfile.test -t $TEST_IMAGE_SPEC .

# Start the app container
# The entry point to scans and starts the application
export SERVICE_NAME_TEST="$APP_IMAGE_NAME"_test
docker run --name $SERVICE_NAME_TEST -d -p 8092:8091 $TEST_IMAGE_SPEC 

# Manual tests
#
# Start the app with the test listener attached as a java agent.
# Report the tests via the Chrome plugin or SL UI.

