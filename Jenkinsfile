pipeline {
    agent any
    environment{
        REACT_APP_VERSION = "1.0.$BUILD_ID"
    }

    stages {
        stage('Deploy to AWS') {
            agent {
                docker {
                    image "amazon/aws-cli"
                    args "--entrypoint=''"
                    reuseNode true
                }
            }
            
            environment{
            }

            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws-S3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                    aws --version
                    aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json
                    '''
                }
            }
        }

        
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }

            steps {
                sh '''
                    # this is a comment in shell script
                    ls -la #list workspace
                    node --version
                    npm --version
                    npm ci # installing dependecies
                    npm run build
                    ls -la #list workspace
                '''

            }
        }
    
}
