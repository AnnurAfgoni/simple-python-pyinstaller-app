pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        stage('Test') {
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
            steps {
                sh 'pyinstaller --onefile sources/add2vals.py'
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals'
                }
            }
        }
    }
}
