def setEnv(region, application_name, aws_service, environment) {
    if( "$environment" == "acc" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/acceptance/${aws_service}/${application_name}"
            env.module_name_prefix="acc_"
        }
    }else if("$environment" == "poc" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/poc/${aws_service}/${application_name}"
            env.module_name_prefix="poc_"
        }
    }else if( "$environment" == "prd-stg" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/production-staging/${aws_service}/${application_name}"
            env.module_name_prefix="prd_stg_"
        }
    }else if( "$environment" == "prd" ){
        script {
            env.repo_path="${env.WORKSPACE}/repository/production/${aws_service}/${application_name}"
            env.module_name_prefix="prd_"
        }
    }
    script {
        env.region="${region}"
        env.application_name = "${application_name}"
        env.environment = "${environment}"
    } 
}


def output() {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform output"
    }
}

def deploy(tfWorkspace, tag) {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform init"
        sh "terraform workspace select ${tfWorkspace} || terraform workspace new ${tfWorkspace}"
        sh "AWS_DEFAULT_REGION=${env.region} terraform plan -var tag=${tag}"
        sh "AWS_DEFAULT_REGION=${env.region} terraform apply -auto-approve -var tag=${tag}"
    }
}

def undeploy(tfWorkspace) {
    dir("${env.repo_path}"){
        sh "AWS_DEFAULT_REGION=${env.region} terraform init"
        sh "terraform workspace select ${tfWorkspace} || terraform workspace new ${tfWorkspace}"
        sh "AWS_DEFAULT_REGION=${env.region} terraform destroy -auto-approve -target=module.${env.module_name_prefix}target_group -target=module.${env.module_name_prefix}aws_alb_listener_rule -target=module.${env.module_name_prefix}ecs_task -target=module.${env.module_name_prefix}ecs_service -target=module.${env.module_name_prefix}app_autoscaling_policy -target=module.${env.module_name_prefix}dns_record -target=module.${env.module_name_prefix}ecs_alerts"        
    }
}

def stoptEcsTask(ecs_cluster_name, service, accessibility) {
    sh  "AWS_DEFAULT_REGION=${env.region} aws ecs list-tasks --cluster ecs-cluster-${ecs_cluster_name}-${service}-${accessibility}-${env.environment} --service ecs-service-${env.application_name}-${service}-${accessibility}-${env.environment} --output text --query taskArns > taskArns"
    sh "echo ecs-cluster-${ecs_cluster_name}-${service}-${accessibility}-${env.environment} > ecs_cluster_name"
    sh "echo ${env.region} > region"
    sh '''
        taskArns=\$(cat taskArns)
        ecs_cluster_name=\$(cat ecs_cluster_name)
        region=\$(cat region)
        for i in $taskArns; do AWS_DEFAULT_REGION=$region aws ecs stop-task --cluster $ecs_cluster_name --task $i; done
    '''
}

pipeline {
    agent {
        docker { 
            image 'test/awscli-ansible-terraform:1.0.8'
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
        string(
            defaultValue: 'latest', 
            description: '', 
            name: 'image_version_poc'
        )
        booleanParam(
            defaultValue: false,
            description: '', 
            name: 'acceptance'
        )
        string(
            defaultValue: 'latest', 
            description: '', 
            name: 'image_version_acceptance'
        )
        booleanParam(
            defaultValue: false,
            description: '', 
            name: 'production_staging'
        )
        string(
            defaultValue: 'latest', 
            description: '', 
            name: 'image_version_production_staging'
        )
        booleanParam(
            defaultValue: false,
            description: '', 
            name: 'production'
        )
        string(
            defaultValue: 'latest', 
            description: '', 
            name: 'image_version_production'
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
                                credentialsId: 'test-git',
                                url: 'ssh://git@build.test.com:2222/test-dev/devops-iaac.git'
                        }
                    }

                }
            }
        }
        stage('Deployment - POC') {
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
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "deploy", "poc")
                            sh "env"
                            deploy("default", "${image_version_poc}")
                            stoptEcsTask("user-app", "dc", "prv")
                            output()                       
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_poc == true 
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
                            setEnv("eu-central-1", "user-app", "deploy", "poc")
                            sh "env"
                            undeploy("default")
                        } 
                    }
                }
            }
        }
        stage('Deployment - Acceptance') {
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
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "deploy", "acc")
                            sh "env"
                            deploy("default", "${image_version_acceptance}")
                            stoptEcsTask("user-app", "dc", "prv")
                            output()                      
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_acceptance == true
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
                            setEnv("eu-central-1", "user-app", "deploy", "acc")
                            sh "env"
                            undeploy("default")
                        }
                    }
                }

            }
        }
        stage('Deployment - Production-Staging') {
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
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "deploy", "prd-stg")
                            sh "env"
                            deploy("default", "${image_version_production_staging}")
                            stoptEcsTask("user-app", "dc", "prv")
                            output()
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_production_staging == true
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
                            setEnv("eu-central-1", "user-app", "deploy", "prd-stg")
                            sh "env"
                            undeploy("default")
                        }
                    }
                }
            }
        }
        stage('Deployment - Production') {
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
                                ]
                            ]
                        )
                        {
                            setEnv("eu-central-1", "user-app", "deploy", "prd")
                            sh "env"
                            deploy("default", "${image_version_production}")
                            stoptEcsTask("user-app", "dc", "prv")
                            output()
                        }
                    }
                }
                stage('De-provisioning') {
                    when {
                        expression { 
                            params.deprovision_production == true
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
                            setEnv("eu-central-1", "user-app", "deploy", "prd")
                            sh "env"
                            undeploy("default")
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