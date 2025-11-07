pipeline {
    agent any

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
                    echo "Check index.html"
                    if [ -f "${WORKSPACE}/build/index.html" ]; then
                        echo "Datei existiert."
                    else
                        echo "Datei existiert nicht."
                    fi
                    echo "npm test"
                    npm test
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
