locals {
  name = "${var.cluster_name}-${var.env}"

  tags = {
    Name = local.name
    Env = var.env
  }

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["*"]
    }
  ]

  ips = flatten([
  for loop in var.server_ip_address_list : [
    join(" ", flatten([
    for network in var.server_ip_address_list : [
      index(var.server_ip_address_list, loop) == index(var.server_ip_address_list, network) ?
      "server.${index(var.server_ip_address_list, loop) + 1}=0.0.0.0:2888:3888;2181" :
      format("server.${index(var.server_ip_address_list, network) + 1}=%s:2888:3888;2181", network)
    ]
    ]))
  ]
  ])

  zoo_user_data = flatten([for url in local.ips : [
    "mkdir -p /zoo_env && chmod -R 777 /zoo_env && echo \"export ZOO_MY_ID=${index(local.ips, url) + 1}\nexport ZOO_SERVERS=\\\"${url}\\\"\" >> /zoo_env/zoo.env"
  ]])

  no_of_ec2_instances = length(var.server_ip_address_list)
}