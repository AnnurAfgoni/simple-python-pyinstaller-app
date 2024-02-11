pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                script {
                    sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                }
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deploy') {
            agent {
                docker {
                    image 'python:3-alpine'
                    args "--entrypoint=''"
                }
            }
            steps {
                script {
                    sh 'pip install pyinstaller'
                    sh 'pyinstaller --onefile sources/add2vals.py'
                }
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals'
                }
            }
        }
    }
}