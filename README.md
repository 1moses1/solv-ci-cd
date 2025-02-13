# CI/CD Pipeline for SOLV Application  

This repository contains a **fully automated CI/CD pipeline** that builds, tests, and deploys the SOLV application to **AWS EKS using GitHub Actions, DockerHub, Helm, and Terraform**.

---

## 📌 Features of this Pipeline
✅ **Automated Build & Push** → Uses **GitHub Actions** to build and push Docker images to **DockerHub**  
✅ **Infrastructure as Code (IaC)** → Deploys **AWS EKS** using **Terraform**  
✅ **Helm-based Deployment** → Manages Kubernetes resources via **Helm Charts**  
✅ **Scalable & Secure** → Leverages **EKS node groups**, IAM roles, and Kubernetes services  
✅ **Observability & Monitoring** → Integrated with **Grafana, Prometheus, Kiali, and Celery**  

---

## 🔧 Prerequisites
Ensure you have the following installed:
- **AWS CLI** → [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **Terraform** → [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- **Helm** → [Install Helm](https://helm.sh/docs/intro/install/)
- **Kubectl** → [Install Kubectl](https://kubernetes.io/docs/tasks/tools/)
- **Docker** → [Install Docker](https://docs.docker.com/get-docker/)

---

## ⚙️ Deployment Steps

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/1moses1/solv-ci-cd.git
cd solv-ci-cd
```

### 2️⃣ Setup AWS Credentials

**Before running Terraform,configure your AWS CLI:**
```bash
aws configure
```
### 3️⃣ Deploy Infrastructure with Terraform

**Initialize and apply Terraform configurations:**
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
**✅ This sets up AWS EKS, VPC, subnets, security groups, and IAM roles.**

### 4️⃣ Configure kubectl to Connect to EKS

```bash
aws eks update-kubeconfig --name solv-cluster --region us-east-1
```
**Test connection:**
```bash
kubectl get nodes
```
**✅ You should see worker nodes running.**

### 5️⃣ Deploy Application to EKS using Helm
```bash
cd helm
helm install solv-app .
```
**Check if deployment is successful:**
```bash
kubectl get pods
kubectl get svc
```
**✅ Application is now running on EKS.**

---

# CI/CD Pipeline Workflow

## CI: Build & Push Docker Image

**Triggered on push to main branch:**

- GitHub Actions pulls the latest code.
- Builds the Docker image.
- Pushes the image to DockerHub.


## CD: Deploy to AWS EKS

**Triggered when CI workflow is completed:**

- Fetches the latest Docker image.
- Updates Kubernetes Deployments & Services.
- Application goes live on AWS EKS.

**✅ View GitHub Actions Workflow**
- CI: ```.github/workflows/build.yml```
- CD: ```.github/workflows/deploy.yml```

---

## 🛠 Managing Deployments

### 📌 Update the Application
**If you push new changes, GitHub Actions will:**
- Build a new Docker image.
- Push it to DockerHub.
- Trigger deployment on AWS EKS.

---

## 🔍 Monitoring & Observability

**Once deployed, access monitoring tools:**
- Grafana Dashboard → View metrics.
- Prometheus → Monitor alerts.
- Kiali → Observe Istio service mesh.
- Celery → Manage background jobs.

**✅ Check running pods and services**
```bash
kubectl get pods
kubectl get svc
```

---

## 🛑 Rollback Deployment

**If an issue occurs, rollback to a previous version:**
```bash
helm rollback solv-app 1
```
**✅ This restores the previous stable version.**

---

## 📌 Cleanup
**To destroy infrastructure:**
```bash
cd terraform
terraform destroy -auto-approve
```
**✅ This removes EKS, VPC, and all resources.**

--- 

## Conclusion

**This CI/CD pipeline enables:**
- ✔️ Automated deployment
- ✔️ Scalability with AWS EKS
- ✔️ Monitoring & security best practices
- ✔️ Infrastructure automation with Terraform

