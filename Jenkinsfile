properties([
        parameters(
                [
                        stringParam(
                                name: 'CHART_NAME',
                                defaultValue: 'datagram'
                        ),
                        choiceParam(
                                name: 'IMAGE_TAG',
                                choices: ['latest', 'redesign-0.1', '0.1']
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
//                        sh "rm -rf /kaniko/workspace/datagram_build"
//                        sh "git clone https://github.com/zanzibeer/${params.CHART_NAME}_build.git /kaniko/workspace/datagram_build"
                        sh "git -C /kaniko/workspace/datagram_build pull"
//                        sh "rm -rf /kaniko/workspace/datagram"
//                        sh "git clone https://github.com/neoflex-consulting/datagram.git -b frontend /kaniko/workspace/datagram"
                        sh "git -C /kaniko/workspace/datagram checkout master" 
                        sh "git -C /kaniko/workspace/datagram pull"
                    }
                }
            }
        }
            
        stage('Build Jar') {
            steps {
                container('maven') {
                    script {
//                        sh "apt-get update && apt-get install -y git"
//                        sh "git checkout frontend && git pull"
//                        sh "rm -rf /kaniko/workspace/datagram/*"
//                        sh "git clone https://github.com/neoflex-consulting/datagram.git -b master"
//                        sh "pwd"
                        sh "mvn clean install -f /root/.m2/datagram/pom.xml"
//                        sh "mvn clean install"
                    }
                }
            }
        }

        stage('Kaniko Build & Push Image') {
              steps {
                container('kaniko') {
                  script {
//                    sh "ls -la /kaniko/workspace"
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
