node {
	currentBuild.result = "SUCCESS"
	try {
		stage ('Clean up') {
			cleanWs()
		}
		stage ('Checkout') {
			checkout scm
		}
		stage ('Terraform init') {
			sh "terraform init"
			sh "terraform get"
			
		}
		stage ('Review Plan') {
			sh "terraform plan -out=plan.out;echo \$? > status"
			env.EXITCODE = readFile('status').trim()
			env.APPLY = "false"
			if (env.EXITCODE == "1") {
				currentBuild.result = 'FAILURE'
			}
			if (env.EXITCODE == "0") {
				currentBuild.result = 'SUCCESS'
			}
		}
		stage ('Approval') {
			try {
				input message: 'Apply Plan?', ok: 'Apply'
				env.APPLY = "true"
			} catch (err) {
				env.APPLY = "false"
				currentBuild.result = 'ABORTED'
			}
		}
		if (env.APPLY == "true") {
			stage ('Terraform Apply') {
				if (fileExists("status.apply")) {
                   sh "rm status.apply"
				}
				sh 'terraform apply;echo \$? > status.apply'
				env.APPLYEXITCODE = readFile('status.apply').trim()
				if (env.APPLYEXITCODE == "0") {
					currentBuild.result = 'SUCCESS'
				} else {
					currentBuild.result = 'FAILURE'
				}
			}
		}
		
	} catch (err) {
		currentBuild.result = 'FAILURE'
	}
}
