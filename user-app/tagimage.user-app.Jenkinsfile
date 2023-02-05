def setEnv(region, image, environment) {
    if( "$environment" == "acc" ){
        script {
            env.registry="745604477182.dkr.ecr.eu-central-1.amazonaws.com"
            env.environment = "acceptance"
        }
    }else if("$environment" == "poc" ){
        script {
            env.registry="572558037834.dkr.ecr.eu-central-1.amazonaws.com"
            env.environment = "poc"
        }
    }else if( "$environment" == "prd-stg" ){
        script {
            env.registry="772089745017.dkr.ecr.eu-central-1.amazonaws.com"
            env.environment = "production-staging"
        }
    }else if( "$environment" == "prd" ){
        script {
            env.registry="985763940395.dkr.ecr.eu-central-1.amazonaws.com"
            env.environment = "production"
        }
    }
    script {
        env.region="${region}"
        env.image = "${image}"
    }
    sh "apk add aws-cli" 
}

def loginRegistry() {
    sh "aws ecr get-login-password --region ${env.region} | docker login --username AWS --password-stdin ${env.registry}"
}

def pull(tag) {
    sh "docker pull ${env.registry}/${env.image}-${env.environment}:$tag"
}

def imageTag(currentTag, releaseTag) {
    sh "docker tag ${env.registry}/${env.image}-${env.environment}:$currentTag ${env.registry}/${env.image}-${env.environment}:$releaseTag"
}

def push(tag) {
    sh "docker push ${env.registry}/${env.image}-${env.environment}:$tag"
}

def removeImage(currentTag, releaseTag) {
    sh "docker rmi ${env.registry}/${env.image}-${env.environment}:$currentTag"
    sh "docker rmi ${env.registry}/${env.image}-${env.environment}:$releaseTag"
}

pipeline {
    // agent {
    //     docker { 
    //         image 'wewash/awscli-ansible-terraform:1.0.10'
    //     }
    // }
    agent any
    parameters {
        string(
            defaultValue: '', 
            description: '', 
            name: 'CurrentTag'
        )
        string(
            defaultValue: '', 
            description: '', 
            name: 'ReleaseTag'
        )
        booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'poc'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'acceptance'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'production_staging'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'production'
        )
    }

    stages {
        stage('Add Release Tag - POC') {
            // agent {
            //     docker { 
            //         image 'jenkinsci/blueocean' 
            //         args '-u root'
            //     }
            // }
            when {
                expression { 
                    params.poc == true
                }
            }
            steps {
                withCredentials(
                    [
                        [
                            $class: 'UsernamePasswordMultiBinding', 
                            credentialsId: 'aws_credentials_poc', 
                            usernameVariable: 'AWS_ACCESS_KEY_ID', 
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]
                ) 
                {
                    setEnv("eu-central-1", "frontend", "poc")
                    sh "env"
                    loginRegistry()
                    pull("${CurrentTag}")
                    imageTag("${CurrentTag}", "${ReleaseTag}")
                    push("${ReleaseTag}")
                    removeImage("${CurrentTag}", "${ReleaseTag}")
                }
            }
        }
        stage('Add Release Tag - Acceptance') {
            when {
                expression { 
                    params.acceptance == true
                }
            }
            steps {
                withCredentials(
                    [
                        [
                            $class: 'UsernamePasswordMultiBinding', 
                            credentialsId: 'aws_credentials_acceptance', 
                            usernameVariable: 'AWS_ACCESS_KEY_ID', 
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]
                ) 
                {
                    setEnv("eu-central-1", "frontend", "acc")
                    sh "env"
                    loginRegistry()
                    pull("${CurrentTag}")
                    imageTag("${CurrentTag}", "${ReleaseTag}")
                    push("${ReleaseTag}")
                    removeImage("${CurrentTag}", "${ReleaseTag}")
                }
            }
        }
        stage('Add Release Tag - Production-Staging') {
            when {
                expression { 
                    params.production_staging == true
                }
            }
            steps {
                withCredentials(
                    [
                        [
                            $class: 'UsernamePasswordMultiBinding', 
                            credentialsId: 'aws_credentials_production_staging', 
                            usernameVariable: 'AWS_ACCESS_KEY_ID', 
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]
                ) 
                {
                    setEnv("eu-central-1", "frontend", "prd-stg")
                    sh "env"
                    loginRegistry()
                    pull("${CurrentTag}")
                    imageTag("${CurrentTag}", "${ReleaseTag}")
                    push("${ReleaseTag}")
                    removeImage("${CurrentTag}", "${ReleaseTag}")
                }
            }
        }
        stage('Add Release Tag - Production') {
            when {
                expression { 
                    params.production == true
                }
            }
            steps {
                withCredentials(
                    [
                        [
                            $class: 'UsernamePasswordMultiBinding', 
                            credentialsId: 'aws_credentials_production', 
                            usernameVariable: 'AWS_ACCESS_KEY_ID', 
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]
                ) 
                {
                    setEnv("eu-central-1", "frontend", "prd")
                    sh "env"
                    loginRegistry()
                    pull("${CurrentTag}")
                    imageTag("${CurrentTag}", "${ReleaseTag}")
                    push("${ReleaseTag}")
                    removeImage("${CurrentTag}", "${ReleaseTag}")
                }
            }
        }
    }
    
    post { 
        success { 
            cleanWs()
        }
    }
}