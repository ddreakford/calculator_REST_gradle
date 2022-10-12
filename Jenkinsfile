pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'The branch to locally clone, build and onboard to SeaLights')
        string(name: 'DOCKER_REPO', defaultValue: 'dwaynedreakford', description: 'Your Docker repo')
        string(name: 'APP_IMAGE_NAME', defaultValue: 'calculator_rest', description: 'Name of the image to be deployed')
    }
    environment {
        SL_APP_NAME = "Calculator-REST-Jenkins-DD"
        SL_BUILD_NAME = "2.0.${BUILD_NUMBER}"
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
                withCredentials([string(credentialsId: 'SL_AGENT_TOKEN', variable: 'SL_TOKEN')]) {
                    // Download the agent
                    // Save the agent token in a file
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

                // Create the config file that will be used to add
                // SeaLights dependencies to build.gradle on the fly
                writeFile file: 'slgradle-gen.json', text: """\
                    |{
                    |    "tokenFile": "sealights/sltoken.txt",
                    |    "createBuildSessionId": false,
                    |    "buildSessionIdFile": "sealights/buildSessionId.txt",
                    |    "appName": "${SL_APP_NAME}",
                    |    "branchName": "${BRANCH}",
                    |    "buildName": "${SL_BUILD_NAME}",
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
                
                // Add SeaLights dependencies to build.gradle
                sh '''
                    cat slgradle-gen.json
                    echo "----------------------------"
                    java -jar sealights/sl-build-scanner.jar -gradle -configfile slgradle-gen.json -workspacepath .
                    echo "----------------------------"
                    cat build.gradle
                '''
            }
        }

        stage('Create the SL Build Session') {
            steps {
                // buildSessionId.txt is written by this step
                sh """
                    java -Dsl.ignoreCertificateErrors=true -jar sealights/sl-build-scanner.jar -config \
                        -tokenfile sealights/sltoken.txt \
                        -appname ${SL_APP_NAME} \
                        -branchname ${BRANCH} \
                        -buildname "${SL_BUILD_NAME}" \
                        -pi '*com.slsamples.gradle.java.springboot*' \
                        -buildsessionidfile sealights/buildSessionId.txt
                    cat sealights/buildSessionId.txt
                """
            }
        }

        stage('Build and Unit Test') {
            steps {
                // Each module built by gradle will be scanned
                // The build map will be reported to SeaLights
                // Any Unit and Integration tests will be monitored
                sh '''
                    gradle clean build
                '''
            }
        }
        stage('Deploy to QA') {
            steps {
                script {
                    // Create/start a container with SeaLights monitoring
                    String APP_IMAGE_SPEC = "${DOCKER_REPO}/${APP_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh """
                        docker build -f Dockerfile.qa -t ${APP_IMAGE_SPEC} .
                        docker run --name ${APP_IMAGE_NAME} -d -p 8091:8091 ${APP_IMAGE_SPEC}
                    """
                }
            }
        }
    }
}