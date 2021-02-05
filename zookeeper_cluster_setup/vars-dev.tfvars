# ZOOKEEPER CLUSTER NAME
cluster_name = "aws-ecs-zookeeper-cluster"

# ZOOKEEPER OFFICIAL IMAGE
docker_image = "zookeeper:latest"

# EC2 INSTANCE TYPE
ec2_instance_type = "t2.micro"

# ZOOKEEPER SERVER IPS - DEPENDS ON YOUR AWS SUBNETS
# TO SCALE UP ADD NEW IP FROM THE LIST, TO SCALE DOWN REMOVE A IP FROM THE LIST
server_ip_address_list = [
  "11.11.1.11", // zookeeper 1
  "11.11.2.12", // zookeeper 2
  "11.11.3.13", // zookeeper 3
]

# EC2 KEY PAIR
ec2_key_pair_name = "zookeeper_ec2_key_pair"

# ENV
env = "dev"

# AWS REGION
aws_region = "eu-central-1"

# VPC DETAILS
vpc_id = "vpc-0f6b47bc99dadac8d"