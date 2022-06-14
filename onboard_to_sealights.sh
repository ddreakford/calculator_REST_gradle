# Onboard the sample REST Calculator service to SeaLights
# Using the Gradle plugin

# Download the SeaLights Java agent
cd $PROJECT_ROOT_DIR
rm -rf sealights
mkdir sealights
wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip
unzip -o -d sealights sealights-java-latest.zip
cp $AGENT_TOKEN_FILE sealights/
rm sealights-java-latest.zip

# Build/update the sl-gradle.json file
# (This step is usually done as part of CI automation)
# <command not shown>

# Add SeaLights dependencies to the Gradle build file, and
# create the SeaLights build session
java -jar sealights/sl-build-scanner.jar -gradle \
    -configfile sl-gradle.json \
    -workspacepath .

# Build and run unit tests
#
# Because SeaLights was dynamically added to the Gradle build
# spec, this command can be run "as usual".
gradle clean build

# Restore the build.gradle file
java -jar sealights/sl-build-scanner.jar -restoreGradle \
    -workspacepath .

# Manual tests
#
# Start the app with the test listener attached as a java agent.
# Report the tests via the Chrome plugin or SL UI.
#
export JAVA_OPTS="-javaagent:sealights/sl-test-listener.jar -Dsl.tokenFile=sealights/sltoken-dev-cs.txt -Dsl.buildSessionIdFile=buildSessionId.txt -Dsl.labId=DevLaptop -Dsl.tags=Calculator-REST -Dsl.testStage='Manual Tests'"
gradle bootRun

# java -jar build/libs/rest-calculator-0.0.1-SNAPSHOT.jar \
#     com.slsamples.gradle.java.springboot.Application \
#     -javaagent:sealights/sl-test-listener.jar \
#     -Dsl.tokenFile=sealights/sltoken-dev-cs.txt \
#     -Dsl.buildSessionIdFile=buildSessionId.txt \
#     -Dsl.labId="DevLaptop" \
#     -Dsl.tags="Calculator_REST" \
#     -Dsl.testStage="Manual Tests"
