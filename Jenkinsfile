node {
    // Clean workspace before doing anything
    deleteDir()
    cleanWs()
    try {
		environment {
			TERRAFORM_CMD = 'docker run --network host " -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light'
		}
        stage ('Checkout Repo') {
            checkout scm
        }
        stage ('Pull terraform docker image') {
            steps {
                sh  """
                    docker pull hashicorp/terraform:light
                    """
            }
        }
        stage ('Initializing') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} init -backend=true -input=false
                    """
            }
        }
		stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -out=tfplan -input=false
                    """
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
            }
        }
		stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false tfplan
                    """
				}
        }
	stage ('Clean up workspace')
	{
	cleanWs()
	deleteDir()
	}
	
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
}
