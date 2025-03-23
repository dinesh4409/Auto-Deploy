pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/22MH1A42H7/auto-deploy.git'
        IMAGE_NAME = 'praveen1772005/dyanmic-web-app'
        DOCKER_SERVER = '43.205.211.216'
        SSH_USER = 'ubuntu'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: "${GIT_REPO}"
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            set -e
                            docker build -t ${IMAGE_NAME}:latest .
                            docker login -u $DOCKER_USER -p $DOCKER_PASS
                            docker push ${IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH-pemkey', keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${SSH_USER}@${DOCKER_SERVER} /bin/bash << 'EOF'
                        set -e
                        docker swarm init || true
                        docker service rm dyanmic-web-app || true
                        docker service create --name dyanmic-web-app --replicas 3 -p 80:80 ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Swarm Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed! Check logs."
        }
    }
}