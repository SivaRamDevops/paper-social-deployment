variable "ibm_region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
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

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "paper-social"
} 