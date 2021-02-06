# MODULE TO MAP IP TO SUBNET
module "ip_to_subnet_mapper" {
  source          = "./modules/ip_subnet_mapping_module"
  network_details = var.server_ip_address_list
  vpc_id          = var.vpc_id
}

# MODULE TO CREATE ECS CLUSTER
module "ecs_cluster" {
  source                = "./modules/ecs_module"
  name                  = local.name
  network_details       = module.ip_to_subnet_mapper.ip_to_subnet_output
  security-group        = module.security-group.this_security_group_id
  tags                  = local.tags
  iam_policy_statements = local.policy_statements
  instance_type         = var.ec2_instance_type
  ec2_volume            = var.ebs
  additional_user_data  = local.zoo_user_data
  key_pair              = var.ec2_key_pair_name
  no_of_ec2_instances   = local.no_of_ec2_instances
}

# CREATE CLOUD WATCH LOG GROUP
resource "aws_cloudwatch_log_group" "module_ecs_log_group" {
  name = local.name
  tags = local.tags
}

# PARSE TASK DEF TEMPLATE
data "template_file" "ecs_task_def_template" {
  template = file(var.ecs_task_def_template_file_path)
  vars = {
    image_url        = var.docker_image
    container_name   = "zookeeper"
    log_group_region = var.aws_region
    log_group_name   = aws_cloudwatch_log_group.module_ecs_log_group.name
    log_prefix_name  = local.name
  }
}

# CREATE TASK DEFINITION
resource "aws_ecs_task_definition" "module_ecs_task_def" {
  family                   = local.name
  container_definitions    = data.template_file.ecs_task_def_template.rendered
  execution_role_arn       = module.ecs_cluster.iam_output["arn"]
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  tags = local.tags

  volume {
    name = "zoo_env"
    host_path = "/zoo_env"
  }

}

# CREATE ECS SERVICE FOR TASKS
resource "aws_ecs_service" "module_ecs_service" {
  name            = local.name
  task_definition = "${aws_ecs_task_definition.module_ecs_task_def.family}:${aws_ecs_task_definition.module_ecs_task_def.revision}"
  desired_count   = length(var.server_ip_address_list)
  launch_type     = "EC2"
  cluster         = module.ecs_cluster.ecs_cluster_output["id"]

  deployment_minimum_healthy_percent = 60
  deployment_maximum_percent = 100

  placement_constraints {
    type = "distinctInstance"
  }

  depends_on = [aws_cloudwatch_log_group.module_ecs_log_group]
}
