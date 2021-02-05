# HIGHLY AVAILABLE ZOOKEEPER CLUSTER SETUP USING AWS ECS 
#### Contents:
1. Intro
2. Prerequisites 
3. Setup
4. Troubleshooting 

## Intro
This repo provides all the necessary code to deploy a highly available Zookeeper cluster on AWS ECS.

#### Features
1. Single command to deploy and modify any size of Zookeeper cluster
2. Single command to perform rolling updates without any downtime
3. Easy to deploy in various environments like development and production

#### Caveats
This setup doesn't use Zookeeper dynamic reconfiguration, so as a result, we can't scale the Zookeeper servers horizontally without downtime. For more info on dynamic reconfiguration, please visit the link
https://zookeeper.apache.org/doc/r3.5.3-beta/zookeeperReconfig.html

To understand more about this setup, please visit the link - 

## Prerequisites
1. AWS Account 
2. AWS Credentials or Profile (Preferably power user) 
3. AWS VPC with NAT/Internet gateway to reach internet (This is required for ECS Cluster to communicate with the ECS services and to pull docker images from public Docker Hub. https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.htm)
4. Terraform >= 0.14

## Setup
1. Clone this repo
```
git clone https://github.com/rab4u/aws_ecs_zookeeper.git
```
2. Update the var-dev.tfvars or var-prod.tfvars depending on your environment

| Parameter              | Default Value                                      | Description                                                                                                                                                                                                       |
|------------------------|----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cluster_name           | aws-ecs-zookeeper-cluster                          | ZOOKEEPER CLUSTER NAME                                                                                                                                                                                            |
| docker_image           | zookeeper:latest                                   | ZOOKEEPER OFFICIAL IMAGE                                                                                                                                                                                          |
| ec2_instance_type      | t2.micro                                           | EC2 INSTANCE TYPE                                                                                                                                                                                                 |
| server_ip_address_list | [   "11.11.1.11",   "11.11.2.12",   "11.11.3.13" ] | ZOOKEEPER SERVER IPS - DEPENDS ON YOUR AWS SUBNETS.  For High availability across AWS availability zones choose different subnets. TO SCALE UP ADD NEW IP FROM THE LIST, TO SCALE DOWN REMOVE A IP FROM THE LIST  |
| ec2_key_pair_name      | zookeeper_ec2_key_pair                             | EC2 KEY PAIR                                                                                                                                                                                                      |
| env                    | dev                                                | ENVIRONMENT                                                                                                                                                                                                       |
| aws_region             | eu-central-1                                       | AWS REGION                                                                                                                                                                                                        |
| vpc_id                 | ""                                                 | VPC DETAILS                                                                                                                                                                                                       |