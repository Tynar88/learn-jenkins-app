pipeline {
    agent any
    environment{
        NETLIFY_SITE_ID = '37fd3fe5-0b4a-4e15-8b88-d82a480236e7'
        NETLIFY_AUTH_TOKEN = credentials('Netlify-token')
    }

    stages {
        // this is a comment
        /*
        block comment
        multiple lines
        */
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
        stage('Run Tests') {
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
                            // image see playwright documentation
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                            //args '-u root:root' --> should not be done
                        }
                    }
                    steps{
                        sh '''
                            npm install serve
                            node_modules/.bin/serve -s build &
                            sleep 10 #wait until server is running
                            npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always{
                            //junit 'jest-results/junit.xml'
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }

            steps {
                sh '''
                    npm install netlify-cli
                    node_modules/.bin/netlify --version
                    echo "Deploying to production. Site-ID $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    '''

            }
        }
    }

    
}
