# Three-Tier EKS DevOps Project

A production-style three-tier application deployed on **Amazon EKS** with **Docker, Amazon ECR, Kubernetes, AWS Application Load Balancer, Terraform, and Jenkins CI/CD**.

## Architecture

```text
                    Internet
                       |
                       v
              AWS Application
              Load Balancer
                 (ALB)
                /     \
               /       \
              v         v
        Frontend      Backend API
        React         Node.js
        :3000         :8080
                         |
                         v
                    MongoDB
                     :27017

CI/CD:
GitHub -> Jenkins -> Docker Build -> Amazon ECR -> EKS Deployment
```

## Technologies

* AWS EKS
* AWS VPC
* AWS Application Load Balancer
* Amazon ECR
* Terraform
* Kubernetes
* Docker
* Jenkins
* GitHub
* React
* Node.js
* MongoDB

## AWS Infrastructure

| Component              | Configuration    |
| ---------------------- | ---------------- |
| Region                 | `ap-south-1`     |
| EKS Cluster            | `threetier-eks`  |
| Kubernetes             | `1.36`           |
| Namespace              | `workshop`       |
| Worker Nodes           | On-Demand + Spot |
| Load Balancer          | AWS ALB          |
| Database               | MongoDB          |
| Infrastructure as Code | Terraform        |

## Kubernetes Components

The `workshop` namespace contains:

* Frontend Deployment
* Backend API Deployment
* MongoDB Deployment
* Frontend Service
* Backend API Service
* MongoDB Service
* AWS ALB Ingress

Check the deployment:

```powershell
kubectl get pods -n workshop
kubectl get svc,ingress -n workshop
```

## Application Access

The application is exposed through an AWS Application Load Balancer.

* Frontend: `/`
* Backend API: `/api`

## Docker

The frontend application is containerized using Docker.

Build locally:

```powershell
docker build -t threetier-frontend:v1 .\app\frontend
```

Production frontend image repository:

```text
949677835392.dkr.ecr.ap-south-1.amazonaws.com/threetier-frontend
```

## Jenkins CI/CD Pipeline

The Jenkins pipeline automatically performs:

1. Checkout source code from GitHub
2. Build the frontend Docker image
3. Authenticate with Amazon ECR
4. Push the Docker image to ECR
5. Update the EKS kubeconfig
6. Update the Kubernetes frontend deployment
7. Wait for the Kubernetes rollout to complete

### Pipeline Flow

```text
GitHub
   |
   v
Jenkins
   |
   v
Docker Build
   |
   v
Amazon ECR
   |
   v
Amazon EKS
   |
   v
Kubernetes Rolling Update
```

## Jenkins Pipeline Verification

The CI/CD pipeline has been successfully tested.

Successful pipeline stages:

```text
Build Frontend       SUCCESS
Login to ECR         SUCCESS
Push Frontend Image  SUCCESS
Deploy to EKS        SUCCESS
Rollout Status       SUCCESS
```

The pipeline successfully deployed frontend image version `14` to the EKS cluster.

## Terraform

Terraform is used to provision the AWS infrastructure.

Main infrastructure includes:

* VPC
* Public and private subnets
* NAT Gateway
* EKS cluster
* EKS managed node groups
* EKS add-ons
* IAM roles
* EBS CSI driver
* AWS Load Balancer Controller

Terraform state is maintained locally for this learning project.

## Useful Commands

### Check EKS cluster

```powershell
aws eks describe-cluster --name threetier-eks --region ap-south-1
```

### Check Kubernetes nodes

```powershell
kubectl get nodes
```

### Check application pods

```powershell
kubectl get pods -n workshop
```

### Check services and ingress

```powershell
kubectl get svc,ingress -n workshop
```

### Check frontend rollout

```powershell
kubectl rollout status deployment/frontend -n workshop
```

### Check application logs

```powershell
kubectl logs deployment/frontend -n workshop
kubectl logs deployment/api -n workshop
```

## Monitoring

Kubernetes resource metrics are currently not enabled in the cluster.

Running:

```powershell
kubectl top pods -n workshop
```

currently returns:

```text
Metrics API not available
```

Metrics Server can be added later if resource-level monitoring is required.

## Project Structure

```text
three-tier-eks-devops/
|
├── app/
│   ├── frontend/
│   └── backend/
|
├── k8s_manifests/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── full_stack_lb.yaml
│   └── mongo/
|
├── terraform/
|
├── docker-compose.yml
├── Jenkinsfile
└── README.md
```

## Local Development

Docker Compose can be used to run the application locally:

```powershell
docker compose up --build
```

Frontend:

```text
http://localhost:3000
```

Stop the local containers:

```powershell
docker compose down
```

## Key DevOps Concepts Demonstrated

* Infrastructure as Code with Terraform
* Containerization with Docker
* Container registry using Amazon ECR
* Kubernetes orchestration with Amazon EKS
* Kubernetes Deployments and Services
* Kubernetes Ingress
* AWS Application Load Balancer
* IAM and IRSA
* Rolling deployments
* Jenkins CI/CD automation
* GitHub source control
* On-Demand and Spot worker nodes

## Author

**G. Rahul Reddy**

B.Tech – Information Technology

GitHub: `Rahul-Reddy9`
