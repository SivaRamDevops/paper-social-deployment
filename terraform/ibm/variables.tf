variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "resource_group" {
  description = "IBM Cloud Resource Group"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the IKS cluster"
  type        = string
  default     = "paper-social-cluster"
}

variable "worker_pool_flavor" {
  description = "Machine type for worker nodes"
  type        = string
  default     = "bx2.4x16"
}

variable "worker_count" {
  description = "Number of worker nodes per zone"
  type        = number
  default     = 1
}

variable "kube_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "ibm_zone" {
  description = "IBM Cloud zone"
  type        = string
  default     = "us-south-1"
}

variable "ibm_image_id" {
  description = "IBM Cloud image ID"
  type        = string
  default     = "r134-1a1a1a1a-1a1a-1a1a-1a1a-1a1a1a1a1a1a" # Ubuntu 20.04
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "paper-social"
} 