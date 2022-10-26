properties([
        parameters(
                [
                        stringParam(
                                name: 'CHART_NAME',
                                defaultValue: 'datagram'
                        ),
                        choiceParam(
                                name: 'IMAGE_TAG',
                                choices: ['latest', 'redesign-0.1']
                        )
                ]
        )
])

// def branch
// def revision
// def registryIp

pipeline {

    options {
        ansiColor('xterm')
        skipDefaultCheckout true
    }

    agent {
        kubernetes {
            yamlFile 'builder.yaml'
        }
    }

    stages {
        
        stage('Clone git repo') {
            steps {
                container('git') {
                    script {
                        sh "chmod -R 666 /kaniko/workspace"
                        sh "cd /kaniko/workspace/"
                        sh "git clone https://github.com/zanzibeer/${params.CHART_NAME}_build.git"
                        sh "ls -la /kaniko/workspace/datagram_build"
                    }
                }
            }
        }

        stage('Kaniko Build & Push Image') {
              steps {
                container('kaniko') {
                  script {
                    sh "ls -la /kaniko/workspace/datagram_build"
                    sh "/kaniko/executor --dockerfile /kaniko/workspace/datagram_build/Dockerfile \
                                     --context /kaniko/workspace/datagram_build \
                                     --force \
                                     --destination=zanzibeer/${params.CHART_NAME}:${params.IMAGE_TAG}"
                  }
                }
              }
            }
//         stage ('build artifact') {
//             steps {
//                 container('docker') {
//                     script {
// //                         registryIp = sh(script: 'getent hosts registry.kube-system | awk \'{ print $1 ; exit }\'', returnStdout: true).trim()
//                         sh "docker build . -t ${registryIp}/datagram/app:${revision} --build-arg REVISION=${revision}"
//                     }
//                 }
//             }
//         }
//         stage ('publish artifact') {
//             when {
//                 expression {
//                     branch == 'master' || params.DEPLOY_BRANCH_TO_TST
//                 }
//             }
//             steps {
//                 container('docker') {
//                     sh "docker push ${registryIp}/demo/app:${revision}"
//                 }
//             }
//         }
//         stage ('deploy to env') {
//             when {
//                 expression {
//                     branch == 'master' || params.DEPLOY_BRANCH_TO_TST
//                 }
//             }
//             steps {
//                 build job: './../Deploy', parameters: [
//                         [$class: 'StringParameterValue', name: 'GIT_REPO', value: 'habr-demo-app'],
//                         [$class: 'StringParameterValue', name: 'VERSION', value: revision],
//                         [$class: 'StringParameterValue', name: 'ENV', value: branch == 'master' ? 'staging' : 'test']
//                 ], wait: false
//             }
//         }
    }
}
