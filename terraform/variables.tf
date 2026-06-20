variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-0c5a50d399817f53a"
}

variable "cluster_name" {
  type        = string
  default     = "dev-eks-cluster"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.30"
}

variable "node_instance_types" {
  type        = list(string)
  default     = ["t2.micro"] # Updated to t2.micro
}