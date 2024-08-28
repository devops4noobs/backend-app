pipeline{
    agent any
    tools {
        jdk 'jdk'
        maven 'maven'
    }
    environment {
        //APP_NAME = "complete-prodcution-e2e-pipeline"
        DOCKER_IMAGE  = "devops4noobs/backend:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID   = "docker-hub-credentials"
        REGISTRY_URL = "https://index.docker.io/v1/"
        //JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")

    }
    stages{
        stage("Checkout from SCM"){
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/devops4noobs/backend-app.git'
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
        
        /* stage("Sonarqube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }

        } */

        /* stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }

        } */

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

        /* stage("Trivy Scan") {
            steps {
                script {
		   sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image dmancloud/complete-prodcution-e2e-pipeline:1.0.0-22 --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }

        } */

        /* stage ('Cleanup Artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        } */


        /* stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'https://jenkins.dev.dman.cloud/job/gitops-complete-pipeline/buildWithParameters?token=gitops-token'"
                }
            }

        } */

    }

    post {
      always {
            // Clean up workspace
            cleanWs()
        }
        /* failure {
            emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed", 
                    mimeType: 'text/html',to: "dmistry@yourhostdirect.com"
            }
         success {
               emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful", 
                    mimeType: 'text/html',to: "dmistry@yourhostdirect.com"
          }    */   
    }
}