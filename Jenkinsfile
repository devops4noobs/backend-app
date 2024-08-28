pipeline {
     agent any 
      tools {
          //jdk 'jdk'
          maven 'maven'
      }

    environment {
        // Define environment variables
        SCANNER_HOME=tool 'sonar-scanner'
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
        /* stage('Database creation') {
                    steps {
                        sh 'docker pull postgres'
                        sh 'docker run --name my_postgres --network my_network -e POSTGRES_DB=postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres'
                    }
        } */

        stage("Sonarqube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }

        }

        stage('Quality Check') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
                }
            }
        }

        stage('OWASP Dependency-Check Scan') {
            steps {
                environment {
                    NDV_API_KEY = "${env.CREDENTIALS_NVD_API_KEY}"
                    }
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'   
            }
        }

        stage('Trivy File Scan') {
            steps {
                    sh 'trivy fs . > trivyfs.txt'
            }
        }

        stage("Build Application"){
            steps {
                sh "mvn clean package"
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

    post {
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}