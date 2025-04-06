# Paper Social - Multi-Cloud Infrastructure

This repository contains the infrastructure as code and deployment configurations for Paper Social's platform, implementing a multi-cloud architecture using AWS EKS and IBM Cloud Kubernetes Service (IKS).

## Architecture Overview

### Infrastructure Components
```
├── Kubernetes Clusters
│   ├── AWS EKS
│   │   ├── 3 worker nodes (t3.medium)
│   │   └── Multi-AZ deployment
│   └── IBM IKS
│       ├── 3 worker nodes (bx2.4x16)
│       └── Multi-zone deployment
├── Networking
│   ├── VPC with private subnets
│   ├── NAT Gateways
│   └── Load Balancers
└── Monitoring Stack
    ├── Prometheus
    ├── Grafana
    └── Loki
```

### Core Services
- NGINX Ingress Controller
- Metrics Server
- Prometheus & Grafana
- Centralized logging with Loki

## Directory Structure
```
paper-social/
├── terraform/           # Infrastructure as Code
│   ├── aws/            # AWS EKS configuration
│   └── ibm/            # IBM IKS configuration
├── k8s/                # Kubernetes manifests
├── ansible/            # Configuration management
├── ci-cd/              # CI/CD pipeline configs
├── monitoring/         # Monitoring configuration
└── app/                # Application code
```

## Prerequisites

### Tools Required
- Terraform >= 1.0
- Ansible >= 2.9
- kubectl
- helm
- AWS CLI
- IBM Cloud CLI
- Docker

### Cloud Provider Setup
1. AWS Configuration:
   ```bash
   aws configure
   ```

2. IBM Cloud Configuration:
   ```bash
   ibmcloud login
   ibmcloud ks cluster config
   ```

## Deployment Pipeline

### 1. Infrastructure Provisioning
```bash
# AWS EKS Deployment
cd terraform/aws
terraform init
terraform apply

# IBM IKS Deployment
cd ../ibm
terraform init
terraform apply
```

### 2. Kubernetes Configuration
```bash
# Configure kubectl for AWS
aws eks update-kubeconfig --region us-west-2 --name paper-social-cluster

# Configure kubectl for IBM
ibmcloud ks cluster config --cluster paper-social-cluster
```

### 3. Application Deployment
```bash
# Deploy core components
kubectl apply -f k8s/

# Verify deployment
kubectl get pods -A
```

## Monitoring and Logging

### Prometheus & Grafana
1. Access Grafana Dashboard:
   ```bash
   kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
   ```
   - Default URL: http://localhost:3000
   - Username: admin
   - Get password:
     ```bash
     kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
     ```

### Centralized Logging
- Loki for log aggregation
- Promtail for log collection
- Access logs through Grafana

### Metrics and Alerts
- Resource utilization metrics
- Application performance metrics
- Custom alert rules
- Integration with communication channels

## Security Considerations

### Network Security
- VPC isolation
- Private subnets for worker nodes
- Security groups and NACLs
- Encrypted communication

### Access Control
- RBAC enabled
- IAM integration
- Pod security policies
- Network policies

### Data Security
- Encrypted storage
- Secrets management
- Regular security updates
- Compliance monitoring

## Cost Optimization

### Infrastructure Costs
- Multi-cloud cost comparison
- Resource optimization
- Autoscaling configuration
- Spot instance usage where applicable

### Monitoring and Optimization
- Resource utilization tracking
- Cost allocation tags
- Regular cost analysis
- Optimization recommendations

## Design Decisions

### Multi-Cloud Strategy
- High availability across cloud providers
- Vendor lock-in prevention
- Geographic distribution
- Cost optimization

### Kubernetes Configuration
- Managed services (EKS/IKS)
- Multi-zone deployment
- Automated scaling
- Standardized monitoring

### CI/CD Pipeline
- GitHub Actions for automation
- Multi-environment deployment
- Automated testing
- Security scanning

## Troubleshooting

### Common Issues
1. Cluster Access:
   ```bash
   # AWS EKS
   aws eks describe-cluster --name paper-social-cluster
   
   # IBM IKS
   ibmcloud ks cluster get --cluster paper-social-cluster
   ```

2. Pod Issues:
   ```bash
   kubectl describe pod <pod-name>
   kubectl logs <pod-name>
   ```

3. Node Issues:
   ```bash
   kubectl get nodes
   kubectl describe node <node-name>
   ```
