pipeline {
    agent any

    environment {
        IMAGE_NAME = "12kishor/sample-node-app:latest"
        KUBECONFIG = "/root/.kube/config"  // Adjust path if Jenkins runs as another user
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/kish-1/jenkin-1.git',
                    credentialsId: 'github-cred'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sh """
                            echo \$PASSWORD | docker login -u \$USERNAME --password-stdin
                            docker push ${IMAGE_NAME}
                        """
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // optional cleanup before deploy
                    sh """
                        export KUBECONFIG=${KUBECONFIG}
                        kubectl delete -f deployment.yaml --ignore-not-found
                        kubectl delete -f service.yaml --ignore-not-found

                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml

                        kubectl rollout status deployment/node-app-deployment
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD complete: App deployed to EKS!'
        }
        failure {
            echo '❌ CI/CD failed.'
        }
    }
}


