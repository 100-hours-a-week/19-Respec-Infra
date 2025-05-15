variables = "env"{

    description = "Environment name {dev, stage, prod}"
    type        = string


}

variable "cidr_block" {

    description = "CIDR block for VPC"
    type        = string

}

variable "public_subnet_cidrs" {

    description = "List of CIDR blocks for public subnets"
    type        = list(string)

}

variable "azs" {

    description = "List of availability zones"
    type        = list(string)
}