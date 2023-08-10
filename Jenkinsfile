pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        
                        
                            git clone "https://gitlab.com/mbbhawsar28/automation-of-ec2-instance.git"
                        
                    }
                }
            }

        stage('Plan') {
            steps {
                 bat label: 'Terraform Init', script: '''
                    
                    terraform init
                '''
                bat label: 'Terraform Plan', script: '''
                   
                    terraform plan -out tfplan
                '''
                bat label: 'Terraform Show', script: '''
                   
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                bat label: 'Terraform Apply', script: '''
                    
                    terraform apply -input=false tfplan
                '''
            }
        }
    }

  }

