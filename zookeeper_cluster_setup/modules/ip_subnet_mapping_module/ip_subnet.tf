data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "subnet_ids" {
  for_each = data.aws_subnet_ids.subnets.ids
  id       = each.value
}

locals {
  subnet_ip_list = flatten([
  for ip in var.network_details: [
    for s in data.aws_subnet.subnet_ids : compact([
    s["cidr_block"] == replace(ip, "/([^.]+)$/", "0/24") ? "${ip}#${s["id"]}" : ""
    ])]
  ])

  network_details = [
      for subnet_ip in local.subnet_ip_list: {ip = split("#",subnet_ip)[0], subnet = split("#",subnet_ip)[1] }
  ]
}

