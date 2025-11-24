pipeline {
    agent any
    environment{
        NETLIFY_SITE_ID = '37fd3fe5-0b4a-4e15-8b88-d82a480236e7'
        NETLIFY_AUTH_TOKEN = credentials('Netlify-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
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
        stage('Tests') {
            parallel{
                stage('Unit Test') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps{
                        sh '''
                            #test -f "${WORKSPACE}/build/index.html" ]
                            npm test
                        '''
                    }
                    post {
                        always{
                            junit 'jest-results/junit.xml'
                            //publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }

                }
                stage('E2E Test') {
                    agent {
                        docker {
                            image 'my-playwright'
                            reuseNode true
                        }
                    }
                    steps{
                        sh '''
                            serve -s build &
                            sleep 10 #wait until server is running
                            npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always{
                            //junit 'jest-results/junit.xml'
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }
        stage('Deploy staging') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }
            environment{
                CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }
            steps{
                sh '''
                    netlify --version
                    echo "Deploying to staging. Site-ID $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --json > deploy-output.json
                    CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' deploy-output.json)
                    sleep 2 #wait until server is running
                    npx playwright test --reporter=html
                '''
            }
            post {
                always{
                    //junit 'jest-results/junit.xml'
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
        }
        
        stage('Deploy Prod') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }
            environment{
                CI_ENVIRONMENT_URL = 'https://wondrous-otter-99403b.netlify.app'
            }
            steps{
                sh '''
                    node --version
                    netlify --version
                    echo "Deploying to production. Site-ID $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --prod 
                    npx playwright test --reporter=html
                '''
            }
            post {
                always{
                    //junit 'jest-results/junit.xml'
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Production E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
        }
    }

    
}
