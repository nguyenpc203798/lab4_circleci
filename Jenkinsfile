pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nguyenpc203/devops-final'
        DOCKER_TAG = 'latest'
        TELEGRAM_CREDS = credentials('telegram-credentials')
        TELEGRAM_BOT_TOKEN = "${TELEGRAM_CREDS_USR}"
        TELEGRAM_CHAT_ID = "${TELEGRAM_CREDS_PSW}"
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
                sh 'docker image pull nguyenpc203/devops-final:latest'
                sh 'docker container stop devops-final || echo "this container does not exist"'
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'docker container run -d --rm --name devops-final -p 4000:4000 --network dev nguyenpc203/devops-final:latest'
            }
        }
    }

    post {
        success {
            script {
                def message = """
                    🎉 *Build Successful!*
                    *Project*: ${env.JOB_NAME}
                    *Build Number*: #${env.BUILD_NUMBER}
                    *Status*: SUCCESS
                    *Duration*: ${currentBuild.durationString}
                """.stripIndent()
                
                sh """
                    curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
                    -d chat_id=${TELEGRAM_CHAT_ID} \
                    -d parse_mode=Markdown \
                    -d text="${message}"
                """
            }
        }
        
        failure {
            script {
                def message = """
                    ❌ *Build Failed!*
                    *Project*: ${env.JOB_NAME}
                    *Build Number*: #${env.BUILD_NUMBER}
                    *Status*: FAILURE
                    *Duration*: ${currentBuild.durationString}
                """.stripIndent()
                
                sh """
                    curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
                    -d chat_id=${TELEGRAM_CHAT_ID} \
                    -d parse_mode=Markdown \
                    -d text="${message}"
                """
            }
        }

        always {
            cleanWs()
        }
    }
}