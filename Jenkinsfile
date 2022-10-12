pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'The branch to locally clone, build and onboard to SeaLights')
        string(name: 'DOCKER_REPO', defaultValue: 'dwaynedreakford', description: 'Your Docker repo')
        string(name: 'APP_IMAGE_NAME', defaultValue: 'calculator_rest', description: 'Name of the image to be deployed')
    }

    stages {
        stage('SCM (Git)') {
            steps {
                cleanWs()
                git branch: params.BRANCH, url: 'https://github.com/ddreakford/calculator_REST_gradle.git'
            }
        }
        stage('Install/Configure SeaLights agent') {
            steps {
                echo "${STAGE_NAME}"
                withCredentials([string(credentialsId: 'SL_AGENT_TOKEN', variable: 'SL_TOKEN')]) {
                    sh '''
                        rm -rf sealights && mkdir sealights
                        wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip
                        unzip -o -d sealights sealights-java-latest.zip
                        rm sealights-java-latest.zip
                        echo "SeaLights agent version is:" `cat sealights/sealights-java-version.txt` "\n"
                        echo $SL_TOKEN > sealights/sltoken.txt
                        ls -l sealights
                    '''
                }
                sh '''
                    cat sealights/sltoken.txt
                '''

                writeFile file: 'slgradle-gen.json', text: """\
                    |{
                    |    "tokenFile": "sealights/sltoken.txt",
                    |    "createBuildSessionId": true,
                    |    "appName": "Calculator-REST-Jenkins-DD",
                    |    "branchName": "main",
                    |    "buildName": "2.0.${BUILD_NUMBER}",
                    |    "packagesIncluded": "*com.slsamples.gradle.java.springboot*",
                    |    "packagesExcluded": "",
                    |    "filesIncluded": "*.class",
                    |    "filesExcluded": "*Test.class*",
                    |    "recursive": true,
                    |    "includeResources": true,
                    |    "testTasksAndStages": {"test":"Unit Tests", "junitPlatformTest":"Unit Tests", "integrationTest":"Integration Tests"},
                    |    "executionType": "full",
                    |    "logEnabled": true,
                    |    "logLevel": "INFO",
                    |    "logToFile": true,
                    |    "logToConsole": false
                    |}
                """.stripMargin().stripIndent()

                sh '''
                    cat slgradle-gen.json
                    echo "----------------------------"
                    java -jar sealights/sl-build-scanner.jar -gradle -configfile slgradle-gen.json -workspacepath .
                    cat build.gradle
                '''
            }
        }
        stage('Build and Unit Test') {
            steps {
                sh '''
                    gradle clean build
                '''
            }
        }
        stage('Deploy to QA') {
            steps {
                // Create/start a container with SeaLights monitoring
                String APP_IMAGE_SPEC = "${DOCKER_REPO}/${APP_IMAGE_NAME}:${BUILD_NUMBER}"
                docker build -f Dockerfile.qa -t ${APP_IMAGE_SPEC} .
                docker run -d -p 8091:8091 $APP_IMAGE_SPEC
            }
        }
    }
}