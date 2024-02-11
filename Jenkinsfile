node {
    def IMAGE_PYTHON = 'python:3.11.4-alpine3.18'
    def IMAGE_PYTEST = 'qnib/pytest'
    def IMAGE_PYINSTALLER = 'cdrx/pyinstaller-linux:python2'
    stage('Build') {
        docker.image(IMAGE_PYTHON).inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    stage('Test') {
        docker.image(IMAGE_PYTEST).inside {
            sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
        }
        junit 'test-reports/results.xml'
    }
    stage('Deploy') {
        def VOLUME = "${pwd()}/sources:/src"
        def BUILD_ID = env.BUILD_ID
        def IMAGE = IMAGE_PYINSTALLER
        node {
            stage('Deploy') {
                docker.image(IMAGE).inside {
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
                }
            }
            stage('Post-Deploy') {
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                archiveArtifacts "${BUILD_ID}/sources/dist/add2vals"
            }
        }
    }
}