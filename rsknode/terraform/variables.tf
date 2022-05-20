variable "project_tag" {
  type = string
  default = "rsk-thegraph-tutorial"
}

variable "region" {
  type = string
}

variable "ec2_ami_id" {
  type = string
}

variable "rsk_node_cluster_size" {
  type = number
}

variable "rsk_node_volume_size" {
  type = string
}

variable "rsk_node_instance_type" {
  type = string
}

variable "subnet_count" {
  type = number
  default = 3
}

