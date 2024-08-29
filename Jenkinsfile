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
               
        dependencyCheck additionalArguments: "--scan ./ --disableYarnAudit --disableNodeAudit --nvdApiKey 5c7f2699-a072-4b9d-a66c-9fc7e4671c8d", odcInstallation: 'DP-Check'
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
                    sh 'docker system prune -f'
                    sh 'docker container prune -f'
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

        stage("Trivy Image Scan") {
            steps {
                sh 'trivy image ${DOCKER_IMAGE} > trivyimage.txt' 
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
