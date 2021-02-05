# ZOOKEEPER CLUSTER NAME
cluster_name = "aws-ecs-zookeeper"

# ZOOKEEPER OFFICIAL IMAGE
docker_image = "zookeeper:latest"

# EC2 INSTANCE TYPE
ec2_instance_type = "t2.micro"

# ZOOKEEPER SERVER IPS - DEPENDS ON YOUR AWS VPC SUBNETS
# TO SCALE UP ADD NEW IP FROM THE LIST, TO SCALE DOWN REMOVE A IP FROM THE LIST
server_ip_address_list = [
  "192.168.100.14", // zookeeper 1
  "192.168.101.15", // zookeeper 2
  "192.168.102.16", // zookeeper 3
  "192.168.101.17", // zookeeper 4
  "192.168.102.18", // zookeeper 5
]

# EC2 KEY PAIR
ec2_key_pair_name = "zookeeper_ec2_key_pair"

# ENV
env = "prod"

# AWS REGION
aws_region = "eu-central-1"

# VPC DETAILS
vpc_id = ""