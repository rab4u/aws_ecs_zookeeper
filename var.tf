# ZOOKEEPER CLUSTER NAME
variable "cluster_name" {
  type = string
}

# ZOOKEEPER SERVER IPS - DEPENDS ON YOUR AWS SUBNETS
# TO SCALE UP ADD NEW IP FROM THE LIST, TO SCALE DOWN REMOVE A IP FROM THE LIST
variable "server_ip_address_list" {
  type = list(string)
}

# EC2 INSTANCE DETAILS
variable "ec2_instance_type" {
  default = "t3.micro"
}

# EBS STORAGE DETAILS
variable "ebs" {
  type = object({
    volume_type = string
    volume_size = string
    delete_on_termination = string
  })
  default = {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = "true"
  }
}

# DOCKER IMAGE
variable "docker_image" {
  type = string
}

# ECS TASK DEFINITION TEMPLATE PATH
variable "ecs_task_def_template_file_path" {
  type    = string
  default = "./ecs_task_template/task_def.json"
}

# VPC DETAILS
variable "vpc_id" {
  type = string
}

# EC2 KEY PAIR
variable "ec2_key_pair_name" {
  type = string
}

# ENV
variable "env" {
  type = string
}

# AWS REGION
variable "aws_region" {
  type = string
}