# Jenkins + AWS EKS + Prometheus + Grafana Deployment Project

## Project Overview

This project demonstrates a complete **DevOps CI/CD pipeline** for deploying a containerized restaurant website application (**Golden Spoon Restaurant Website**) on AWS EKS using:

* Terraform for Infrastructure Provisioning
* Docker for Containerization
* Jenkins for CI/CD Automation
* Kubernetes (EKS) for Application Deployment
* Prometheus for Monitoring
* Grafana for Visualization
* Helm for Monitoring Stack Deployment

This project is designed as a real-world production-style DevOps implementation and is highly suitable for interview demonstrations.

---

## Tech Stack

* HTML + CSS (Restaurant Website)
* Docker
* Jenkins
* Terraform
* AWS EKS
* Kubernetes
* Helm
* Prometheus
* Grafana
* DockerHub

---

## Project Architecture

```text
GitHub
   ↓
Jenkins Pipeline
   ↓
Terraform (AWS Infra + EKS)
   ↓
Docker Build + Push to DockerHub
   ↓
Kubernetes Deployment on EKS
   ↓
Prometheus + Grafana Monitoring
```

---

## Jenkins Pipeline Stages

### 1. Git Clone

Jenkins pulls the latest source code from GitHub repository.

### 2. Terraform Apply

Terraform performs:

* terraform init
* terraform validate
* terraform plan
* terraform apply -auto-apply

This creates:

* VPC
* Subnets
* Security Groups
* IAM Roles
* EKS Cluster
* Worker Nodes

### 3. Docker Build & Push

Jenkins:

* Builds Docker image
* Logs into DockerHub
* Pushes image to DockerHub repository

### 4. Kubernetes Deployment

Jenkins:

* Updates kubeconfig for EKS
* Connects to cluster
* Deploys application using:

  * deployment.yaml
  * service.yaml

### 5. Monitoring Deployment

Jenkins installs:

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* kube-state-metrics

using Helm and kube-prometheus-stack.

---

## Folder Structure

```text
Jenkins-AWS-EKS-Prometheus-Grafana-deployment/
│
├── Jenkinsfile
│
├── Dockerfile
│
├── index.html
|
│
├── K8S/
│   ├── deployment.yaml
│   └── service.yaml
│
├── Terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   
│   
│
└── README.md
```

---

## Jenkinsfile Used

The pipeline performs complete infrastructure provisioning, application deployment, and monitoring automation.

### Main Features

* Fully automated deployment
* Terraform infrastructure lifecycle
* Docker image build and push
* Kubernetes deployment to EKS
* Monitoring stack deployment
* Production-style CI/CD flow

---

## Required Jenkins Credentials

### AWS Credentials
### DockerHub Credentials


## Required Tools Installed on Jenkins Server

Make sure Jenkins server has:

* AWS CLI
* kubectl
* Docker
* Terraform
* Helm
* Git

installed and configured.

---

## Grafana Access

### Port Forward

```bash
kubectl port-forward svc/monitoring-grafana 3000:80
```

Then open:

```text
http://localhost:3000
```

### Default Login

```text
Username: admin
```

Password can be fetched using:

```powershell
kubectl get secret monitoring-grafana -o jsonpath="{.data.admin-password}" | %{ [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

---

## Important Dashboards Imported

Grafana Dashboard IDs:

* 1860 → Node Exporter Full
* 315 → Kubernetes Cluster Monitoring
* 6417 → Pod Monitoring
* 8588 → Deployment Metrics

---

## Key Learning Outcomes

This project demonstrates:

* End-to-End CI/CD Pipeline Design
* Infrastructure as Code (IaC)
* Kubernetes Production Deployment
* Monitoring & Observability
* AWS EKS Administration
* Jenkins to EKS Integration
* Terraform Destroy Strategy
* DevOps Best Practices

---
## Future Improvements

Recommended next upgrades:

* ArgoCD GitOps
* Ingress + Domain + HTTPS
* Blue-Green Deployment
* Canary Deployment
* SonarQube + Trivy DevSecOps
* Slack / Email Alerting
* Production-grade IAM Roles

---

## Author

Project created and deployed as a complete DevOps learning.

Designed for practical hands-on experience with real production workflows.

---
