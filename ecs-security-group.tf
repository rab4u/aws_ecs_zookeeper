data "aws_vpc" "vpc" {
  id = var.vpc_id
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  # REQUIRED PARAMS
  vpc_id      = var.vpc_id
  name        = local.name
  description = "${local.name} security group"

  ingress_with_cidr_blocks = [
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "allow ssh"
    },
    {
      from_port   = "8"
      protocol    = "icmp"
      to_port     = "0"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "enable ping"
    },
    {
      from_port   = 2181
      to_port     = 2181
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "zookeeper client port"
    },
    {
      from_port   = 2888
      to_port     = 2888
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "zookeeper quorum port"
    },
    {
      from_port   = 3888
      to_port     = 3888
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "zookeeper leader election port"
    },
    {
      from_port   = 7000
      to_port     = 7000
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
      description = "zookeeper metrics port from smava office"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "default egress"
    }
  ]

  tags = local.tags
}
