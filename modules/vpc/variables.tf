
variable "cidr_block" {

    description = "CIDR block for VPC"
    type        = string

}


variable "vpc_cidr" {

    type = string
    default = "10.0.0.0.24"

}

variable "azs" {

    type = list(string)
    default = ["ap-northest-2a", "ap-northest-2c"]


}

variable "public_subnet_cidrs"{

    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_app_subnet_cidrs"{

    type = list(string)
    default = ["10.0.11.0/24", "10.0.21.0/24"]


}

variable "private_db_subnet_cidrs" {
    type = list(string)
    default = ["10.0.12.0/24", "10.0.22.0/24"]

}


variable "env"{

    description = "Environment name {dev, stage, prod}"
    type        = string


}

