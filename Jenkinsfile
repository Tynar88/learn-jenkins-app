pipeline {
    agent any

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
        stage('Test') {
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

        }
        stage('E2E') {
            agent {
                docker {
                    // image see playwright documentation
                    image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                    reuseNode true
                }
            }
            steps{
                sh '''
                    npm install -g serve
                    serve -s build
                    npx playwright test
                '''
            }

        }
    
    }

    post {
        always{
            junit 'test-results/junit.xml'
        }
    }
}
