# Kubernetes Deployment Guide

This directory contains Kubernetes manifests for deploying the Paper Social application.

## Prerequisites

- Kubernetes cluster (1.19+)
- kubectl configured to communicate with your cluster
- Docker image built and accessible to your cluster

## Components

1. `deployment.yaml`: Defines the application deployment with 3 replicas
2. `service.yaml`: Creates a ClusterIP service to expose the application internally
3. `configmap.yaml`: Contains non-sensitive configuration
4. `ingress.yaml`: Configures ingress for external access

## Deployment Steps

1. Build and push the Docker image:
```bash
docker build -t paper-social:latest ../app
docker tag paper-social:latest your-registry/paper-social:latest
docker push your-registry/paper-social:latest
```

2. Update the image reference in `deployment.yaml` to match your registry.

3. Apply the Kubernetes manifests:
```bash
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

4. Verify the deployment:
```bash
kubectl get pods -l app=paper-social
kubectl get svc paper-social
kubectl get ingress paper-social-ingress
```

## Monitoring

The deployment includes readiness and liveness probes that check the `/health` endpoint.

## Scaling

You can scale the deployment using:
```bash
kubectl scale deployment paper-social --replicas=5
```

## Configuration

Update the `configmap.yaml` file to modify environment variables. For sensitive data, create a Secret (not included) and reference it in the deployment. 