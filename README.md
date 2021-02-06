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
5. AWS S3 Bucket to store terraform state remotely
6. EC2 key pair (later used to SSH into the ec2 instances for troubleshooting)

## Setup
1. Clone this repo
```
git clone https://github.com/rab4u/aws_ecs_zookeeper.git
```
2. Update the var-dev.tfvars or var-prod.tfvars depending on your environment

| Parameter              	| Type         	| Default Value                                      	| Description                                                                                                                                                                                                       	|
|------------------------	|--------------	|----------------------------------------------------	|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| cluster_name           	| string       	| aws-ecs-zookeeper-cluster                          	| ZOOKEEPER CLUSTER NAME                                                                                                                                                                                            	|
| docker_image           	| string       	| zookeeper:latest                                   	| ZOOKEEPER OFFICIAL IMAGE                                                                                                                                                                                          	|
| ec2_instance_type      	| string       	| t2.micro                                           	| EC2 INSTANCE TYPE                                                                                                                                                                                                 	|
| server_ip_address_list 	| list(string) 	| [   "11.11.1.11",   "11.11.2.12",   "11.11.3.13" ] 	| ZOOKEEPER SERVER IPS - DEPENDS ON YOUR AWS SUBNETS.  For High availability across AWS availability zones choose different subnets. TO SCALE UP ADD NEW IP FROM THE LIST, TO SCALE DOWN REMOVE A IP FROM THE LIST  	|
| ec2_key_pair_name      	| string       	| zookeeper_ec2_key_pair                             	| EC2 KEY PAIR                                                                                                                                                                                                      	|
| env                    	| string       	| dev                                                	| ENVIRONMENT                                                                                                                                                                                                       	|
| aws_region             	| string       	| eu-central-1                                       	| AWS REGION                                                                                                                                                                                                        	|
| vpc_id                 	| string       	| ""                                                 	| VPC ID. please provide VPC ID                                                                                                                                                                                     	|

3. Export AWS credentials
For AWS Profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
```
export AWS_PROFILE=<<profile name>>
export AWS_SDK_LOAD_CONFIG=1
```
For AWS Credentials
```
export AWS_ACCESS_KEY_ID="<<Access key id>>"
export AWS_SECRET_ACCESS_KEY="<<Secret Access key>>"
# IF SESSION TOKEN IS PRESENT
export AWS_SESSION_TOKEN="<<Session Token>>"
```

4. Export Terraform init parameters
```
export bucket="<<AWS S3 bucket name>>"
export TF_CLI_ARGS_init="-backend-config=\"bucket=${bucket}\""
```

5. Initialize terraform
```
terraform init
```
6. Check the terraform plan (around 28 resources will be created)
```
terraform plan
```
7. terraform apply
```
terraform apply --var-file=vars-dev.tfvars 
```

Hurrah !! In a few minutes Zookeeper cluster will be up and running 

## Troubleshooting 
