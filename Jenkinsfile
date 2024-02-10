pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
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

        stage("Manual Approval"){
            steps{
                script{
                    def userInput = input(
                        id: "manualApproval",
                        message: "Lanjutkan ke tahap Deploy?",
                        parameters: [
                            choice(choices: 'Proceed\nAbort', description: 'Pilih opsi', name: 'approvalChoice')
                        ]
                    )
                    if (userInput == "Proceed"){
                        echo "continuing..."
                    } else {
                        currentBuild.result = "ABORTED"
                        error("Aborted by user")
                    }
                }
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'cdrx/pyinstaller-linux:python3'
                }
            }
            steps {
                sh 'pyinstaller --onefile sources/add2vals.py'
                script{
                    echo 'Deployment completed successfully.'
                }
            }
        }
    }
}
