pipeline {
    agent any

    environment {
        SL_TOKEN = credentials('SL_AGENT_TOKEN')
    }

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'The branch to locally clone, build and onboard to SeaLights')
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
                sh '''
                    rm -rf sealights && mkdir sealights
                    wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip
                    unzip -o -d sealights sealights-java-latest.zip
                    rm sealights-java-latest.zip
                    echo "SeaLights agent version is:" `cat sealights/sealights-java-version.txt` "\n"
                    echo -n "$SL_TOKEN" > sealights/sltoken.txt
                    ls -l sealights
                '''
                writeFile file: 'slgradle.json', text: '''\
                    |{
                    |    "tokenFile": "sealights/sltoken.txt",
                    |    "createBuildSessionId": true,
                    |    "appName": "Calculator-REST-Jenkins-DD",
                    |    "branchName": "main",
                    |    "buildName": "2.${BUILD_NUMBER}",
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
                    |    "logToConsole": true
                    |}
                '''.stripMargin().stripIndent()
                sh '''
                    cat slgradle.json
                '''
            }
        }
        stage('Build and Unit Tests') {
            steps {
                echo "${STAGE_NAME}"
            }
        }
        stage('Start local REST Calculator') {
            when { 
                environment name: 'START_CALCULATOR', value: 'YES'
            }
            steps {
                echo "${STAGE_NAME}"
            }
        }
    }
}