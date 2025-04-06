# Paper Social - IBM Cloud Kubernetes Infrastructure

This directory contains the infrastructure as code for deploying Paper Social on IBM Cloud Kubernetes Service (IKS).

## Infrastructure Overview

### IBM Kubernetes Service (IKS) Cluster
- Cluster Name: `paper-social-cluster`
- Kubernetes Version: 1.27
- Region: us-south
- High Availability: Multi-zone deployment across 3 zones
- Worker Node Flavor: bx2.4x16 (4 vCPU, 16GB RAM)

### Node Configuration
- Type: VPC Worker Nodes
- Nodes per zone: 1 (total 3 nodes)
- Auto-scaling enabled
- Operating System: Red Hat Enterprise Linux

### Networking
- VPC-based cluster
- Three subnets (one per zone)
- Public gateways for internet access
- Private worker nodes
- LoadBalancer service type for ingress

## Core Components

### 1. NGINX Ingress Controller
- Namespace: ingress-nginx
- Type: LoadBalancer
- Purpose: External traffic routing

### 2. Metrics Server
- Namespace: kube-system
- Purpose: Pod autoscaling support

### 3. Monitoring Stack
- Namespace: monitoring
- Components:
  - Prometheus for metrics collection
  - Grafana for visualization
- Service Type: ClusterIP

## Prerequisites

1. IBM Cloud CLI
2. IBM Cloud Kubernetes Service plugin
3. Terraform >= 1.0
4. kubectl
5. helm

## Deployment Steps

1. Configure IBM Cloud credentials:
```bash
ibmcloud login
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the plan:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

5. Configure kubectl:
```bash
ibmcloud ks cluster config --cluster paper-social-cluster
```

## Monitoring and Management

### Access Cluster Dashboard
```bash
ibmcloud ks cluster get --cluster paper-social-cluster
```

### Access Grafana
1. Get Grafana admin password:
```bash
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

2. Port forward Grafana:
```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

### View Logs
```bash
ibmcloud ks worker ls --cluster paper-social-cluster
kubectl logs -n <namespace> <pod-name>
```

## Security Features

- VPC isolation
- Private worker nodes
- RBAC enabled
- Network policies support
- Encrypted etcd
- Regular security updates

## Cost Optimization

- Multi-zone deployment for high availability
- Resource limits and requests configured
- Autoscaling enabled
- Monitoring for resource usage

## Troubleshooting

1. Check cluster status:
```bash
ibmcloud ks cluster get --cluster paper-social-cluster
```

2. Check worker nodes:
```bash
ibmcloud ks worker ls --cluster paper-social-cluster
```

3. View cluster events:
```bash
kubectl get events --all-namespaces
```

## Support

For issues:
1. Check IBM Cloud status
2. Review cluster logs
3. Consult IBM Cloud documentation
4. Open support ticket if needed 