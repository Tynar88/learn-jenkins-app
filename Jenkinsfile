pipeline {
    agent any
    environment{
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'us-east-1'
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
                    aws ecs update-service --cluster LearnJenkinsMatt-Cluster-Prod --service LearnJenkinsMatt-Service-Prod --task-definition LearnJenkinsMatt-TaskDef-Prod:$LATEST_TD_REVISION
                    aws ecs wait services-stable --cluster LearnJenkinsMatt-Cluster-Prod --services LearnJenkinsMatt-Service-Prod
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
