terraform {
  required_version = ">= 1.0"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.54.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "ibm" {
  region = var.region
}

data "ibm_container_vpc_cluster_config" "cluster_config" {
  cluster_name_id   = ibm_container_vpc_cluster.cluster.id
  resource_group_id = data.ibm_resource_group.group.id
}

provider "kubernetes" {
  host  = ibm_container_vpc_cluster.cluster.master_url
  token = data.ibm_container_vpc_cluster_config.cluster_config.token
  cluster_ca_certificate = base64decode(
    ibm_container_vpc_cluster.cluster.master_cert
  )
} 