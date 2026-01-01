pipeline {
    agent any
    environment{
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ECS_CLUSTER = 'LearnJenkinsMatt-Cluster-Prod'
        AWS_ECS_SERVICE = 'LearnJenkinsMatt-Service-Prod'
        AWS_ECS_TD_PROD = 'LearnJenkinsMatt-TaskDef-Prod'
    }

    stages {
        stage('Deploy to AWS') {
            agent {
                docker {
                    image "amazon/aws-cli"
                    args "-u root --entrypoint=''"
                    reuseNode true
                }
            }
            


            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws-S3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                    aws --version
                    yum install jq -y
                    # yum ist ein Paketmanager --> RedHeat
                    # jq für json
                    LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json | jq -r '.taskDefinition.revision')
                    #echo $LATEST_TD_REVISION
                    aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE --task-definition $AWS_ECS_TD_PROD:$LATEST_TD_REVISION
                    aws ecs wait services-stable --cluster $AWS_ECS_CLUSTER --services $AWS_ECS_SERVICE
                    '''
                }
            }
        }

        /*
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
        */
    
    }
}
