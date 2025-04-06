# Paper Social - Kubernetes Infrastructure

This repository contains the infrastructure as code and deployment configurations for the Paper Social application using Kubernetes on AWS EKS.

## Infrastructure Overview

### AWS EKS Cluster
- Cluster Name: `paper-social-cluster`
- Kubernetes Version: 1.27
- Region: us-west-2
- High Availability: Multi-AZ deployment across us-west-2a, us-west-2b, us-west-2c

### Node Groups
- Type: EKS Managed Node Group
- Instance Type: t3.medium
- Capacity: ON_DEMAND
- Autoscaling:
  - Minimum: 2 nodes
  - Desired: 3 nodes
  - Maximum: 5 nodes

### Networking
- VPC CIDR: 10.0.0.0/16
- Private Subnets: 
  - 10.0.1.0/24 (us-west-2a)
  - 10.0.2.0/24 (us-west-2b)
  - 10.0.3.0/24 (us-west-2c)
- Public Subnets:
  - 10.0.101.0/24 (us-west-2a)
  - 10.0.102.0/24 (us-west-2b)
  - 10.0.103.0/24 (us-west-2c)
- NAT Gateway: Single NAT gateway for cost optimization
- DNS: Enabled (hostnames and DNS support)

## Core Components

### 1. NGINX Ingress Controller
- Namespace: ingress-nginx
- Type: LoadBalancer
- Purpose: Handles external traffic routing to services

### 2. Metrics Server
- Namespace: kube-system
- Purpose: Enables pod autoscaling and resource metrics

### 3. Monitoring Stack
- Namespace: monitoring
- Components:
  - Prometheus: Metrics collection and storage
  - Grafana: Metrics visualization and dashboards
- Service Type: ClusterIP (internal access)

## Directory Structure
```
.
├── k8s/                    # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── ingress.yaml
└── terraform/
    └── aws/
        ├── eks.tf         # EKS cluster configuration
        ├── vpc.tf         # VPC and networking
        ├── helm.tf        # Helm releases
        ├── variables.tf   # Variable definitions
        ├── outputs.tf     # Output definitions
        └── providers.tf   # Provider configurations
```

## Deployment Guide

### Prerequisites
1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0
3. kubectl
4. helm

### Infrastructure Deployment

1. Initialize Terraform:
```bash
cd terraform/aws
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the infrastructure:
```bash
terraform apply
```

4. Configure kubectl for EKS:
```bash
aws eks update-kubeconfig --region us-west-2 --name paper-social-cluster
```

### Application Deployment

1. Deploy the application:
```bash
kubectl apply -f k8s/
```

2. Verify the deployment:
```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

## Monitoring and Maintenance

### Access Grafana Dashboard
1. Get the Grafana admin password:
```bash
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

2. Port forward Grafana service:
```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

3. Access Grafana at: http://localhost:3000 (username: admin)

### Scaling
- Manual scaling:
```bash
kubectl scale deployment paper-social --replicas=5
```
- The cluster will automatically scale between 2 and 5 nodes based on resource utilization

## Security

- OIDC Provider configured for pod IAM roles
- Private subnets for worker nodes
- Controlled public access to API server
- Network policies should be configured as needed

## Tags and Labels

All resources are tagged with:
- Environment: production
- Terraform: true
- GithubRepo: paper-social

## Troubleshooting

1. Check pod status:
```bash
kubectl get pods -A
kubectl describe pod <pod-name>
```

2. View logs:
```bash
kubectl logs <pod-name>
```

3. Check node status:
```bash
kubectl get nodes
kubectl describe node <node-name>
```

## Cost Optimization

- Single NAT Gateway used instead of one per AZ
- Node autoscaling configured
- t3.medium instances used for cost-effective performance

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## Support

For issues and support:
1. Check the logs using kubectl
2. Review Grafana dashboards for metrics
3. Consult AWS EKS documentation
4. Open an issue in the repository 