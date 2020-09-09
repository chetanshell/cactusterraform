# cactusterraform

#Infrastructure will be launched based on these terraform variables

ecs_cluster="$cluster name"
ecs_key_pair_name="$Keypairs"
region = "$region-id"
cactus_vpc = "$VPC name"
cactus_cidr = "$VPC CIDR range"
public_cidr_01 = "$public subnet cidr range"
public_cidr_02 = "$public subnet cidr range"
max_instance_size = "$max of instance"
min_instance_size = "$min no of instance"
desired_capacity = "$no of instance to be running"

#ECR image is built from Codebuild
https://github.com/chetanshell/cactus-codebuild/tree/master

