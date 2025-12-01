variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  type        = string
  # Ubuntu 22.04 LTS in us-east-1
  # Find AMI for your region: https://cloud-images.ubuntu.com/locator/ec2/
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.small"  # Free tier: t2.micro, but t2.small is better for Strapi
}

variable "key_name" {
  description = "Name of the SSH key pair (must exist in AWS)"
  type        = string
  # You need to create this key pair in AWS Console first!
}

variable "admin_email" {
  description = "Admin email for Strapi"
  type        = string
  default     = "bashairfan518@gmail.com"
}

variable "admin_password" {
  description = "Admin password for Strapi (minimum 8 characters)"
  type        = string
  sensitive   = true
  default     = "Irfan@86101"
}

variable "my_ip" {
  description = "Your IP address for SSH access (format: x.x.x.x/32)"
  type        = string
  default     = "0.0.0.0/0"  # Change this to your IP for better security
}