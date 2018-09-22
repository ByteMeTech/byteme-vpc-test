node {
 
   // Mark the code checkout 'Checkout'....
   stage ('Checkout'){
   // deleteDir()
   cleanWs() 
   // // Get some code from a GitHub repository
   // git url: 'git://github.com:knott-sphere/infrastructure.git'
checkout scm 
   // Get the Terraform tool.
   // def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
   // env.PATH = "${tfHome}:${env.PATH}"
  // wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
 }
           // Mark the code build 'plan'....
           stage ('Plan'){
           // Output Terraform version
           sh "terraform --version"
           //Remove the terraform state file so we always start from a clean state
           if (fileExists(".terraform/terraform.tfstate")) {
               sh "rm -rf .terraform/terraform.tfstate"
           }
           if (fileExists("status")) {
               sh "rm status"
           }
           // sh "./init"
	   sh "terraform init" 
           sh "terraform get"
           // sh "echo \$PWD"
           // sh "whoami"
           sh "terraform plan -out=plan.out;echo \$? > status"
           def exitCode = readFile('status').trim()
           def apply = false
           // echo "Terraform Plan Exit Code: ${exitCode}"
           if (exitCode == "0") {
               // echo "Terraform Plan Exit Code: ${exitCode}"
               // slackSend channel: '#midwesthackerschool', color: '#0080ff', message: "Plan Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
               currentBuild.result = 'SUCCESS'
           }
           if (exitCode == "1") {
               // sh "terraform destroy -force"
               // echo "Terraform Plan Exit Code: ${exitCode}"
               // slackSend channel: '#midwesthackerschool', color: '#0080ff', message: "Infrastructure Destroyed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
               currentBuild.result = 'FAILURE'
           }
           if (exitCode == "0") {
               // echo "Terraform Plan Exit Code: ${exitCode}"
               // stash name: "plan", includes: "plan.out"
               // slackSend channel: '#midwesthackerschool', color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
               try {
                   input message: 'Apply Plan?', ok: 'Apply'
                   apply = true
               } catch (err) {
                   // slackSend channel: '#midwesthackerschool', color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                   apply = false
                   // sh "terraform destroy -force"
                   currentBuild.result = 'ABORTED'
               }
           }
	   } // end plan stage
           if (apply) {
               stage ('Apply') {
               //unstash 'plan'
               if (fileExists("status.apply")) {
                   sh "rm status.apply"
               }
               sh 'terraform apply;echo \$? > status.apply'
               def applyExitCode = readFile('status.apply').trim()
               if (applyExitCode == "0") {
                   // slackSend channel: '#midwesthackerschool', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
               } else {
                   // slackSend channel: '#midwesthackerschool', color: 'danger', message: "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                   // sh "terraform destroy -force"
                   currentBuild.result = 'FAILURE'
               }
	       }
           }
}
