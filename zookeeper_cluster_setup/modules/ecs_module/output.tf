output "ec2_instance_output" {
  value = aws_instance.ec2_instance
}

output "ecs_cluster_output" {
  value = aws_ecs_cluster.module_ecs_cluster
}

output "iam_output" {
  value = aws_iam_role.module-service-role
}