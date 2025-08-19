variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "sg_ingress_cidr" {
  description = "CIDR allowed to access port 80"
  type        = string
  default     = "0.0.0.0/0"
}

variable "create_bucket" {
  description = "Whether to create an S3 bucket"
  type        = bool
  default     = false
}
