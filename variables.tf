# Vars for terraform
variable "bucket-name" {
  description = "S3 bucket name for storing tfstate"
  type        = string
  default     = "newreliccodechallenge-nick"
}

variable "vpc-cidr-block" {
  description = "The cidr block for the VPC"
  type        = string
  default     = "10.33.0.0/16"
}

variable "subnet-cidr-block" {
  description = "The cidr block for subnet"
  type        = string
  default     = "10.33.1.0/24"
}

variable "subnet-cidr-block2" {
  description = "The cidr block for subnet2"
  type        = string
  default     = "10.33.2.0/24"
}

variable "webserver-port" {
  description = "Webserver port"
  type        = string
  default     = "80"
}

variable "instance-count" {
  description = "The number of instances to be deployed"
  type        = string
  default     = "2"
}

variable "instance-type" {
  description = "The type of instance to use"
  type        = string
  default     = "t3.micro"
}
