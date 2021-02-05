variable "name" {
  type = string
}

variable "network_details" {
  type = list(object({
    subnet = string
    ip = string
  }))
}

variable "instance_type" {
  type = string
}

variable key_pair {
  type = string
}

variable "security-group" {
  type = string
}

variable "ec2_volume" {
  type = object({
    volume_type = string
    volume_size = string
    delete_on_termination = string
  })
}

variable "ec2_ebs_optimized" {
  type = string
  default = "false"
}

variable "iam_policy_statements" {
  type = list(object({
    actions = list(string)
    resources = list(string)
    effect = string
  }))
}

variable "default_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

variable "policies" {
  type = list(string)
  default = []
}

variable "additional_user_data" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "no_of_ec2_instances" {
  type = string
}