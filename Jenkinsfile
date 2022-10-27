properties([
        parameters(
                [
                        stringParam(
                                name: 'CHART_NAME',
                                defaultValue: 'datagram'
                        ),
                        stringParam(
                                name: 'IMAGE_TAG',
                                defaultValue: 'latest'
                        ),
                        choiseParam(
                                name: 'BRANCH',
                                choises: ['master', 'frontend']
                        )
                ]
        )
])

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
                        sh "git -C /kaniko/workspace/datagram_build pull"
                        sh "git -C /kaniko/workspace/datagram checkout ${params.BRANCH}" 
                        sh "git -C /kaniko/workspace/datagram pull"
                    }
                }
            }
        }
            
        stage('Build Jar') {
            steps {
                container('maven') {
                    script {
                        sh "mvn clean install -f /root/.m2/datagram/pom.xml"
                    }
                }
            }
        }

        stage('Kaniko Build & Push Image') {
              steps {
                container('kaniko') {
                  script {
                    sh "/kaniko/executor --dockerfile /root/.m2/datagram_build/Dockerfile \
                                     --context /root/.m2 \
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
