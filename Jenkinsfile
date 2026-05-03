pipeline {
    agent any

    environment {

        IMAGE_REPO  = "ramesh040183"
        IMAGE_NAME  = "goldenspoon"
        IMAGE_TAG   = "latest"
        AWS_REGION  = "ap-south-1"
        EKS_CLUSTER = "my-cluster"

    }

    stages {
        stage('git_clone') {
            steps {

                git branch: 'main', 
                    url: 'https://github.com/ramesh040183-code/Jenkins-AWS-EKS-Prometheus-Grafana-deployment.git'              
                
                
            }
        }

        stage('docker_build_push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'Dockerhub-creds', 
                        passwordVariable: 'PASSWORD', 
                        usernameVariable: 'USERNAME')]) {
                
                bat '''

                docker build -t %IMAGE_REPO%/%IMAGE_NAME%:%IMAGE_TAG% .

                echo %PASSWORD% | docker login -u %USERNAME% --password-stdin

                docker push %IMAGE_REPO%/%IMAGE_NAME%:%IMAGE_TAG%                
               
                '''
                }
            }
        }

        stage('terraform_apply') {
            steps {
                dir ('Terraform') {
                withCredentials([
                    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    credentialsId: 'AWS_Cred', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')])  {                
                
                bat ''' 

                terraform destroy -auto-approve
                
                // terraform init 

                // terraform validate

                // terraform plan

                // terraform apply -auto-approve 
                
                '''
                    }
                }
            }
        }

        stage('K8S_deployment') {
            steps {
                withCredentials([
                    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    credentialsId: 'AWS_Cred', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')])  {                
                
                bat ''' 
                
                aws eks update-kubeconfig --region %AWS_REGION% --name %EKS_CLUSTER%

                kubectl get nodes

                kubectl apply -f K8S/deployment.yaml

                kubectl apply -f K8S/service.yaml
                                        
                '''

                }
            }
        }

        stage('monitoring_deployment') {
            steps {
                withCredentials([
                    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    credentialsId: 'AWS_Cred', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')])  {                
                
                bat ''' 
                
                aws eks update-kubeconfig --region %AWS_REGION% --name %EKS_CLUSTER%

                helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
                
                helm repo update

                helm upgrade --install monitoring prometheus-community/kube-prometheus-stack
                                        
                '''
                
                }
            }
        }        
    }

    post {
        success {
            echo "pipeline executed successfully!!"
        }

        failure {
            echo "failed! check logs!!"
        }
    }
}
