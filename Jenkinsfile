pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:3.11.4-alpine3.18'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Manual Approval') {
            steps {
                script {
                    def userInput = input(
                        id: 'manualApproval',
                        message: 'Lanjutkan ke tahap Deploy?',
                        parameters: [
                            choice(choices: 'Proceed\nAbort', description: 'Pilih opsi', name: 'approvalChoice')
                        ]
                    )
                    if (userInput == 'Proceed') {
                        echo 'User selected Proceed. Continuing to Deploy stage.'
                    } else {
                        echo 'User selected Abort. Aborting pipeline execution.'
                        currentBuild.result = 'ABORTED'
                        error('Pipeline execution aborted by user.')
                    }
                }
            }
        }
        stage('Deploy') { 
            agent any
            environment { 
                VOLUME = '$(pwd)/sources:/src'
                IMAGE = 'cdrx/pyinstaller-linux:python2'
            }
            steps {
                dir(path: env.BUILD_ID) { 
                    unstash(name: 'compiled-results') 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
                }
            }
            post {
                success {
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                    sh "sleep 1m"
                }
            }
        }
    }
}