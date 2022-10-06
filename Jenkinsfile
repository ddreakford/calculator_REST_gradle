pipeline {
    agent any
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
                echo ${STAGE_NAME}
            }
        }
        stage('Build and Unit Tests') {
            steps {
                echo ${STAGE_NAME}
            }
        }
        stage('Start local REST Calculator') {
            when { 
                environment name: 'START_CALCULATOR', value: 'YES'
            }
            steps {
                echo ${STAGE_NAME}
            }
        }
    }
}