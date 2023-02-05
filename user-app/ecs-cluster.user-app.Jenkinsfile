def setEnv(region, application_name, aws_service, environment) {
    if( "$environment" == "acc" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/acceptance/${aws_service}/${application_name}"
            env.var="TF_VAR_root_user_prv_key_acceptance"
        }
    }else if("$environment" == "poc" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/poc/${aws_service}/${application_name}"
            env.var="TF_VAR_root_user_prv_key_poc"
        }
    }else if( "$environment" == "prd-stg" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/production-staging/${aws_service}/${application_name}"
            env.var="TF_VAR_root_user_prv_key_production_staging"
        }
    }else if( "$environment" == "prd" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/production/${aws_service}/${application_name}"
            env.var="TF_VAR_root_user_prv_key_production"
        }
    }
    script {
        env.region="${region}"
        env.application_name = "${application_name}"
    } 
}

def output() {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform output"
    }
}

def createCluster(tfWorkspace) {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform init"
        sh "terraform workspace select ${tfWorkspace} || terraform workspace new ${tfWorkspace}"
        sh "${env.var}=\$(cat ${env.root_user_prv_key}) AWS_DEFAULT_REGION=${env.region} terraform plan"
        sh "${env.var}=\$(cat ${env.root_user_prv_key}) AWS_DEFAULT_REGION=${env.region} terraform apply -auto-approve"  
    }
}

def destroyCluster(tfWorkspace) {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform init"
        sh "terraform workspace select ${tfWorkspace} || terraform workspace new ${tfWorkspace}"
        sh "${env.var}=\$(cat ${env.root_user_prv_key}) AWS_DEFAULT_REGION=${env.region} terraform plan"
        sh "${env.var}=\$(cat ${env.root_user_prv_key}) AWS_DEFAULT_REGION=${env.region} terraform destroy -auto-approve"   
    }
}

pipeline {
    agent {
        docker { 
            image 'wewash/awscli-ansible-terraform:1.0.8'
        }
    }
    parameters {
        string(
            defaultValue: 'master', 
            description: '', 
            name: 'BranchOrTag'
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
        booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'deprovision_poc'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'deprovision_acceptance'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'deprovision_production_staging'
        )
            booleanParam(
            defaultValue: false, 
            description: '', 
            name: 'deprovision_production'
        )
    }

    stages {
        stage ('Clone infrastructure-pipeline repository') {
            parallel {
                stage ('Reference:tag'){
                    when {
                        expression { 
                            params.BranchOrTag != ''
                        }
                    }
                    steps {
                        sh 'mkdir -p repository'
                        dir("repository")
                        {
                            git branch: params.BranchOrTag,
                                credentialsId: 'we-wash-git',
                                url: 'ssh://git@build.we-wash.com:2222/wewash-dev/devops-iaac.git'
                        }
                    }

                }
            }
        }
        stage('Infrastructure - POC') {
            parallel {
                stage('Provisioning') {
                    when {
                        expression { 
                            params.deprovision_poc == false && params.poc == true
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ] 
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "poc")
                            sh "env"
                            createCluster("default")
                            output()                        
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_poc == true && params.poc == false
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "poc")
                            sh "env"
                            destroyCluster("default")
                        } 
                    }
                }
            }
        }
        stage('Infrastructure - Acceptance') {
            parallel {
                stage('Provisioning') {
                    when {
                        expression { 
                            params.deprovision_acceptance == false && params.acceptance == true
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "acc")
                            sh "env"
                            createCluster("default")
                            output() 
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_acceptance == true && params.acceptance == false
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "acc")
                            sh "env"
                            destroyCluster("default")
                        }
                    }
                }

            }
        }
        stage('Infrastructure - Production-Staging') {
            parallel {
                stage('Provisioning') {
                    when {
                        expression { 
                            params.deprovision_production_staging == false && params.production_staging == true
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "prd-stg")
                            sh "env"
                            createCluster("default")
                            output()  
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_production_staging == true && params.production_staging == false
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "prd-stg")
                            sh "env"
                            destroyCluster("default")
                        }
                    }
                }
            }
        }
        stage('Infrastructure - Production') {
            parallel {
                stage('Provisioning') {
                    when {
                        expression { 
                            params.deprovision_production == false && params.production == true
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "prd")
                            sh "env"
                            createCluster("default")
                            output()  
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_production == true && params.production == false
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
                                ],
                                [
                                    $class: 'SSHUserPrivateKeyBinding', 
                                    credentialsId: "we-wash-git", 
                                    keyFileVariable: 'root_user_prv_key',
                                    passphraseVariable: '',
                                    usernameVariable: 'we-wash-git'    
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "ecs-cluster", "prd")
                            sh "env"
                            destroyCluster("default")
                        }
                    }
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