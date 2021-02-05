# CREATES ECS CLUSTER
resource "aws_ecs_cluster" "module_ecs_cluster" {
  name = var.name
  tags = var.tags
}

# CREATE NETWORK INTERFACES FOR THE EC2 INSTANCES WITH FIXED IP
resource "aws_network_interface" "ecs_ec2_network_interface" {
  count = length(var.network_details) > 0 ? var.no_of_ec2_instances: 0
  subnet_id = var.network_details[count.index].subnet
  private_ips = [var.network_details[count.index].ip]
  security_groups = [var.security-group]
  tags = var.tags
}

# GET LATEST ECS OPTIMIZED AMI
data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

# CREATE EC2 INSTANCE
resource "aws_instance" "ec2_instance" {
  count = var.no_of_ec2_instances
  ami = jsondecode(data.aws_ssm_parameter.ecs_ami_id.value)["image_id"]
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.module-instance-profile.name
  key_name = var.key_pair
  ebs_optimized = var.ec2_ebs_optimized

  dynamic "network_interface" {
    for_each = var.network_details
    content {
      device_index = 0
      network_interface_id = aws_network_interface.ecs_ec2_network_interface[count.index].id
      delete_on_termination = "false"
    }
  }

  user_data = <<EOF
                              #!/bin/bash
                              echo ECS_CLUSTER="${var.name}" >> /etc/ecs/ecs.config
                              echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"awslogs\",\"fluentd\",\"gelf\",\"json-file\",\"journald\",\"splunk\",\"logentries\",\"syslog\"]" >> /etc/ecs/ecs.config
                              ${length(var.additional_user_data) != 0 ? var.additional_user_data[count.index]: ""}
                              EOF
  root_block_device {
    volume_type = var.ec2_volume.volume_type
    volume_size = var.ec2_volume.volume_size
    delete_on_termination = var.ec2_volume.delete_on_termination
  }


  tags = var.tags
  depends_on = [aws_ecs_cluster.module_ecs_cluster]
}