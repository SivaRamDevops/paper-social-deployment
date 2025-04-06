resource "ibm_is_vpc" "vpc" {
  name                      = "paper-social-vpc"
  resource_group            = data.ibm_resource_group.group.id
  address_prefix_management = "auto"
  tags = [
    "environment:${var.environment}",
    "project:paper-social",
    "terraform:true"
  ]
}

resource "ibm_is_public_gateway" "gateway1" {
  name           = "gateway-1"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_public_gateway" "gateway2" {
  name           = "gateway-2"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-2"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_public_gateway" "gateway3" {
  name           = "gateway-3"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-3"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_subnet" "subnet1" {
  name                     = "subnet-1"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway1.id
  resource_group           = data.ibm_resource_group.group.id
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "subnet-2"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-2"
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway2.id
  resource_group           = data.ibm_resource_group.group.id
}

resource "ibm_is_subnet" "subnet3" {
  name                     = "subnet-3"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-3"
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway3.id
  resource_group           = data.ibm_resource_group.group.id
} 