pipeline {
    agent {
        docker {
            image 'docker:dind'
            args '--privileged'
        }
    }

    environment {
        DOCKER_IMAGE = 'nguyenpc203/devops_final'
        DOCKER_TAG = 'latest'
        DOCKER_HOST = 'tcp://192.168.99.100:2376'
        DOCKER_CERT_PATH = '/path/to/certs'
        DOCKER_TLS_VERIFY = '1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/nguyenpc203798/devops-final.git'
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
                sh 'docker image pull trongpham99/golang-jenkins:latest'
                sh 'docker container stop golang-jenkins || echo "this container does not exist"'
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '

                sh 'docker container run -d --rm --name server-golang -p 4000:3000 --network dev nguyenpc203/devops_final:latest'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}