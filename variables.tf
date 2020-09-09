
variable "ecs_cluster" {
  description = "Define ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "Create EC2 instance key pair name"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    us-east-2 = "us-east-2"
  }
}

variable "cactus_vpc" {
  description = "Define VPC name"
}

variable "cactus_cidr" {
  description = "Define IP address for VPC"
}

variable "public_cidr_01" {
  description = "Define public CIDR range"
}

variable "public_cidr_02" {
  description = "Define public CIDR range"
}

variable "max_instance_size" {
  description = "Define maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Define minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Define desired number of instances in the cluster"
}

# variable "ami_id" {
#   description = "Define the AMI image id"
# }

# variable "instance_type" {
#   description = "Define instance type for ec2"
# }

