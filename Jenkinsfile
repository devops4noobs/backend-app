pipeline {
     agent any 
      tools {
          //jdk 'jdk'
          maven 'maven'
      }

    environment {
        // Define environment variables
        DOCKER_IMAGE  = "devops4noobs/backend:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID   = "docker-hub-credentials"
        REGISTRY_URL = "https://index.docker.io/v1/"
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }

        stage("Build Application"){
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }

        }

        stage("Test Application"){
            steps {
                sh "mvn test"
            }

        }

        /*stage('Test') {
            steps {
                // Run tests for the React application
                sh 'npm test -- --watchAll=false'
                // If you're using yarn, you would do: sh 'yarn test --watchAll=false'
            }
        }*/

        stage('Build Docker Image') {
            steps {
                // Build Docker image
                script {
                    docker.build(DOCKER_IMAGE)
                    //dockerImage = docker.build('registry:$BUILD_NUMBER')
                }
            }
        }

        

        stage("Push Docker Image") {
            steps {
                script {
                    docker.withRegistry(REGISTRY_URL, DOCKER_CREDENTIALS_ID) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }

        }
      }

    /* post {
        always {
            // Clean up workspace
            cleanWs()
        }
    } */
}