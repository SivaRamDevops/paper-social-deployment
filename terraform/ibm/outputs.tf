output "cluster_id" {
  description = "ID of the created cluster"
  value       = ibm_container_vpc_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the cluster"
  value       = ibm_container_vpc_cluster.cluster.name
}

output "cluster_state" {
  description = "State of the cluster"
  value       = ibm_container_vpc_cluster.cluster.state
}

output "cluster_ingress_hostname" {
  description = "Ingress hostname of the cluster"
  value       = ibm_container_vpc_cluster.cluster.ingress_hostname
}

output "cluster_master_url" {
  description = "URL for cluster master"
  value       = ibm_container_vpc_cluster.cluster.master_url
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = ibm_is_vpc.vpc.id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value = [
    ibm_is_subnet.subnet1.id,
    ibm_is_subnet.subnet2.id,
    ibm_is_subnet.subnet3.id
  ]
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = data.ibm_resource_group.group.id
} 