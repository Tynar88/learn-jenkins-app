pipeline {
    agent any
    environment{
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        APP_NAME = 'learnjenkinsapp'
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ECS_CLUSTER = 'LearnJenkinsMatt-Cluster-Prod'
        AWS_ECS_SERVICE = 'LearnJenkinsMatt-Service-Prod'
        AWS_ECS_TD_PROD = 'LearnJenkinsMatt-TaskDef-Prod'
        AWS_ECR_DOCKER_REGISTRY = '995138771033.dkr.ecr.us-east-1.amazonaws.com'
    }

    stages {
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

        stage('Build Docker Image') {
            agent {
                docker {
                    image "my-aws-cli"
                    args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
                    reuseNode true
                }
            }
            steps{
                withCredentials([usernamePassword(credentialsId: 'my-aws-S3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        docker build -f Dockerfile -t $AWS_ECR_DOCKER_REGISTRY/$APP_NAME:$REACT_APP_VERSION .
                        aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ECR_DOCKER_REGISTRY  
                        docker push $AWS_ECR_DOCKER_REGISTRY/$APP_NAME:$REACT_APP_VERSION
                    '''
                }
            }
        }



        stage('Deploy to AWS') {
            agent {
                docker {
                    image 'my-aws-cli'
                    reuseNode true
                    args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
                }
            }
            


            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws-S3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                    aws --version
                    # yum ist ein Paketmanager --> RedHeat
                    # jq für json
                    sed -i "s/#APP_VERSION#/$REACT_APP_VERSION/g" aws/task-definition-prod.json
                    # sed - stream editor
                    LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json | jq -r '.taskDefinition.revision')
                    #echo $LATEST_TD_REVISION
                    aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE --task-definition $AWS_ECS_TD_PROD:$LATEST_TD_REVISION
                    aws ecs wait services-stable --cluster $AWS_ECS_CLUSTER --services $AWS_ECS_SERVICE
                    '''
                }
            }
        }

        
        
        
    
    }
}
