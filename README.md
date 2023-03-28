# Calculator REST service built with Spring Boot
This project is used to demonstrate various techniques for onboarding a Java application to SeaLights for quality analytics.

## CI/CD stack
- Jenkins: job automation
- Gradle: build
- Docker: deploy the service via container

## Onboard to SeaLights using Gradle plugin
See [Jenkinsfile](https://github.com/ddreakford/calculator_REST_gradle/blob/main/Jenkinsfile)

## Onboard to SeaLights using the Java CD agent
See [onboard_with_cd_agent.sh](https://github.com/ddreakford/calculator_REST_gradle/blob/main/onboard_with_cd_agent.sh)

## Onboard an app build that has been provided as a Docker image
See [onboard_container_to_sealights.sh](https://github.com/ddreakford/calculator_REST_gradle/blob/main/onboard_container_to_sealights.sh)

## SeaLights Test Sessions API usage sample
See [Jenkinsfile.TSAPI](https://github.com/ddreakford/calculator_REST_gradle/blob/main/Jenkinsfile.TSAPI)

## Api Endpoints

### /add
GET http://localhost:8091/calculator/+/9/2/

### /sub
GET http://localhost:8091/calculator/-/11/2/

### /mul
GET http://localhost:8091/calculator/*/3/7/

### /div
GET http://localhost:8091/calculator/d/21/3/
