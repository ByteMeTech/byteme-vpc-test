node {
    // Clean workspace before doing anything
    deleteDir()
    cleanWs()
    try {

        stage ('Checkout Repo') {
            checkout scm
        }
        stage ('Pull terraform docker image') {
                sh  'docker pull hashicorp/terraform:light'
        }
        stage ('Initializing') {
		sh "docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light init -backend=true -input=false"
        }
        stage('plan') {
                sh  "docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light plan -out=tfplan -input=false"
                    
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy?", ok: 'Deploy')
                  }
            }
        }
        stage('apply') {
        sh  "docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light apply -lock=false -input=false tfplan"
        }

        stage ('Clean up workspace') {
        cleanWs()
        deleteDir()
        }

    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
	cleanWs()
	deleteDir()
    }
}


