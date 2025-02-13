# ===========================
# Terraform Variables for AWS EKS
# ===========================

# Define the AWS region where the infrastructure will be deployed
variable "region" {
  description = "AWS region where the EKS cluster will be provisioned"
  default     = "us-east-1"
}

# Name of the EKS cluster
variable "cluster_name" {
  description = "Name assigned to the AWS EKS cluster"
  default     = "solv-cluster"
}

# Specify the AWS Availability Zone for the deployment
# Since the requirement states a Single AZ, we use only one AZ.
variable "availability_zone" {
  description = "AWS Availability Zone for the EKS cluster deployment"
  type        = string
  default     = "us-east-1a"
}
