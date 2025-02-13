provider "aws" {
  region = var.region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

# EKS Cluster
resource "aws_eks_cluster" "solv_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }
}

# Create Subnets
resource "aws_subnet" "eks_subnets" {
  count = 2
  vpc_id = aws_vpc.solv_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(var.availability_zones, count.index)
}

# Create VPC
resource "aws_vpc" "solv_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "solv-vpc"
  }
}

# EKS Node Group
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.solv_cluster.name
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids      = aws_subnet.eks_subnets[*].id
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

# Security Group for EKS
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.solv_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
