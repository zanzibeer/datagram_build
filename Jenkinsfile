properties([
        parameters(
                [
                        booleanParam(
                                name: 'DEPLOY_BRANCH_TO_TST',
                                defaultValue: false
                        )
                ]
        )
])

def branch
def revision
def registryIp

pipeline {

    agent {
        kubernetes {
            label 'build-service-pod'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    job: build-service
spec:
  containers:
  - name: docker
    image: docker:git
    command: ["cat"]
    tty: true
"""
        }
    }
    options {
        skipDefaultCheckout true
    }

    stages {
        stage ('compile') {
            steps {
                container('maven') {
                    sh 'mvn clean compile test-compile'
                }
            }
        }
        stage ('integration test') {
            steps {
                container ('maven') {
                    sh 'mvn verify'
                }
            }
        }
        stage ('build artifact') {
            steps {
                container('maven') {
                    sh "mvn package -Dmaven.test.skip -Drevision=${revision}"
                }
                container('docker') {
                    script {
                        registryIp = sh(script: 'getent hosts registry.kube-system | awk \'{ print $1 ; exit }\'', returnStdout: true).trim()
                        sh "docker build . -t ${registryIp}/demo/app:${revision} --build-arg REVISION=${revision}"
                    }
                }
            }
        }
        stage ('publish artifact') {
            when {
                expression {
                    branch == 'master' || params.DEPLOY_BRANCH_TO_TST
                }
            }
            steps {
                container('docker') {
                    sh "docker push ${registryIp}/demo/app:${revision}"
                }
            }
        }
        stage ('deploy to env') {
            when {
                expression {
                    branch == 'master' || params.DEPLOY_BRANCH_TO_TST
                }
            }
            steps {
                build job: './../Deploy', parameters: [
                        [$class: 'StringParameterValue', name: 'GIT_REPO', value: 'habr-demo-app'],
                        [$class: 'StringParameterValue', name: 'VERSION', value: revision],
                        [$class: 'StringParameterValue', name: 'ENV', value: branch == 'master' ? 'staging' : 'test']
                ], wait: false
            }
        }
    }
}