pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nguyenpc203/devops_final'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/nguyenpc203798/devops_final.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Golang to DEV') {
            steps {
                echo 'Deploying to DEV...'
                sh 'docker image pull nguyenpc203/devops_final:latest'
                sh 'docker container stop devops_final || echo "this container does not exist"'
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'docker container run -d --rm --name devops_final-v1 -p 3000:3000 --network dev nguyenpc203/devops_final:latest'
            }
        }

        stage('Deploy Golang to PROD') {
            steps {
                echo 'Deploying to PROD...'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}