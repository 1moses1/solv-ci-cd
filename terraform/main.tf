# ===========================
# AWS Provider Configuration
# ===========================
provider "aws" {
  region = var.region
}

# ===========================
# IAM Role for EKS Cluster
# ===========================
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" } # Allows EKS to assume this role
    }]
  })
}

# ===========================
# AWS EKS Cluster Configuration
# ===========================
resource "aws_eks_cluster" "solv_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn # IAM Role for cluster permissions

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id # Associate subnets with the cluster
  }
}

# ===========================
# Networking Configuration
# ===========================

# VPC Creation
resource "aws_vpc" "solv_vpc" {
  cidr_block = "10.0.0.0/16" # Define VPC CIDR range
  enable_dns_support = true  # Enable DNS resolution
  enable_dns_hostnames = true # Enable DNS hostnames within the VPC
  tags = {
    Name = "solv-vpc"
  }
}

# Subnet Creation (Single AZ)
resource "aws_subnet" "eks_subnets" {
  count = 1 # Only one subnet (Single AZ Deployment)
  vpc_id = aws_vpc.solv_vpc.id
  cidr_block = "10.0.0.0/24" # Define CIDR range for the subnet
  availability_zone = var.availability_zone # Assign the subnet to a single AZ
}

# ===========================
# EKS Node Group (Worker Nodes)
# ===========================
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.solv_cluster.name # Attach the node group to the EKS cluster
  node_role_arn   = aws_iam_role.eks_role.arn # Assign IAM role for node group
  subnet_ids      = aws_subnet.eks_subnets[*].id # Deploy nodes in the created subnet
  instance_types  = ["t3.medium"] # Define instance type for worker nodes

  scaling_config {
    desired_size = 2  # Default number of nodes
    max_size     = 3  # Maximum number of nodes
    min_size     = 1  # Minimum number of nodes
  }
}

# ===========================
# Security Group for EKS Cluster
# ===========================
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.solv_vpc.id # Attach security group to VPC

  # Allow all inbound and outbound traffic (Modify as needed)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to all traffic (Not recommended for production)
  }
}
