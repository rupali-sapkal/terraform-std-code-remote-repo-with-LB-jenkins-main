pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'uat', 'prod'])
        choice(name: 'ACTION', choices: ['apply', 'plan', 'destroy'])
        string(name: 'BRANCH', defaultValue: 'main')
    }

    triggers {
        githubPush()
    }

    environment {
        TF_VAR_environment = "${params.ENV}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]],
                    userRemoteConfigs: [[url: 'https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git']]
                )
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                terraform init -reconfigure \
                -backend-config="key=${params.ENV}/terraform.tfstate"
                """
            }
        }

        stage('Workspace') {
            steps {
                sh """
                terraform workspace select ${params.ENV} || terraform workspace new ${params.ENV}
                """
            }
        }

        stage('Validate') {
            steps {
                sh "terraform validate"
                sh "terraform fmt -check"
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    def tfvars = "envs/${params.ENV}.tfvars"

                    if (params.ACTION == 'plan') {
                        sh "terraform plan -var-file=${tfvars}"
                    }
                    else if (params.ACTION == 'apply') {
                        sh "terraform apply -auto-approve -var-file=${tfvars}"
                    }
                    else {
                        sh "terraform destroy -auto-approve -var-file=${tfvars}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ ${params.ACTION} completed for ${params.ENV}"
        }
        failure {
            echo "❌ ${params.ACTION} failed"
        }
    }
}