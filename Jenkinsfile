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
                 bat label: 'Creating the GitHub Repo', script: '''
                            dir("terraform3")
                            cd terraform3
                            git clone "https://github.com/Dkjagad/EC2_Launch.git"  
                    '''
                }
            }

        stage('Plan') {
            steps {
                 bat label: 'Terraform Init', script: '''
                    cd terraform3
                    terraform init
                '''
                bat label: 'Terraform Plan', script: '''
                    cd terraform3
                    terraform plan -out tfplan
                '''
                bat label: 'Terraform Show', script: '''
                    cd terraform3
                    terraform show -no-color terraform3/tfplan > tfplan.txt
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
                    def plan = readFile 'cd terraform3/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                bat label: 'Terraform Apply', script: '''
                    cd terraform3
                    terraform apply -input=false tfplan
                '''
            }
        }
    }

  }

