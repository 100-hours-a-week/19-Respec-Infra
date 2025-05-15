variable "env" {
    description = "Environment name (dev, stage, prod)"
    type        = string

}

variable "ami_id"{

    description = "AMI ID to use for EC2 instance"
    type        = string
}


variable "instance_type" {

    description = "EC2 instance type"
    type        = string

}

variable "subnet_id" {
    description = "Subnet ID where EC2 instance will be deployed"
    type        = string

}

variable "key_name"{

    description = "SSH key pair name"
    type        = string
}

variable "image"{

    description = "Docker image to run on EC2"
    type        = string
}