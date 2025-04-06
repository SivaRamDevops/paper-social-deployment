terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.0"
    }
  }
}

provider "ibm" {
  region = var.ibm_region
}

# Resource Group
resource "ibm_resource_group" "main" {
  name = "${var.project_name}-${var.environment}"
}

# VPC
resource "ibm_vpc" "main" {
  name           = "${var.project_name}-vpc"
  resource_group = ibm_resource_group.main.id
}

# Subnet
resource "ibm_is_subnet" "main" {
  name                     = "${var.project_name}-subnet"
  vpc                      = ibm_vpc.main.id
  zone                     = var.ibm_zone
  total_ipv4_address_count = 256
  resource_group           = ibm_resource_group.main.id
}

# Security Group
resource "ibm_is_security_group" "main" {
  name           = "${var.project_name}-sg"
  vpc            = ibm_vpc.main.id
  resource_group = ibm_resource_group.main.id
}

# Security Group Rules
resource "ibm_is_security_group_rule" "ssh" {
  group     = ibm_is_security_group.main.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "http" {
  group     = ibm_is_security_group.main.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "https" {
  group     = ibm_is_security_group.main.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "outbound" {
  group     = ibm_is_security_group.main.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

# SSH Key
resource "ibm_is_ssh_key" "main" {
  name           = "${var.project_name}-key"
  public_key     = var.ssh_public_key
  resource_group = ibm_resource_group.main.id
}

# Virtual Server Instance
resource "ibm_is_instance" "main" {
  name           = "${var.project_name}-instance"
  vpc            = ibm_vpc.main.id
  zone           = var.ibm_zone
  profile        = "bx2-2x8"
  image          = var.ibm_image_id
  keys           = [ibm_is_ssh_key.main.id]
  resource_group = ibm_resource_group.main.id

  primary_network_interface {
    subnet          = ibm_is_subnet.main.id
    security_groups = [ibm_is_security_group.main.id]
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              EOF
}

# Floating IP
resource "ibm_is_floating_ip" "main" {
  name           = "${var.project_name}-fip"
  target         = ibm_is_instance.main.primary_network_interface[0].id
  resource_group = ibm_resource_group.main.id
}

# Log Analysis Service
resource "ibm_resource_instance" "log_analysis" {
  name              = "${var.project_name}-logs"
  service           = "logdna"
  plan              = "lite"
  location          = var.ibm_region
  resource_group_id = ibm_resource_group.main.id
}

# Outputs
output "instance_ip" {
  value = ibm_is_floating_ip.main.address
}

output "instance_id" {
  value = ibm_is_instance.main.id
} 