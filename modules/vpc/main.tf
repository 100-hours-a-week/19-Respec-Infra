resource "aws_vpc" "main"{

    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {

        Name = "$(var.env)-vpc"
    }
}


resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.main.id
    tags = {Name = "main-igw"}

}

resource "aws_nat_gateway" "nat"{

    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id
    tags = {

        Name = "main-nat"
    }

}

resource "aws_eip" "nat"{

    domain = "vpc"
}

resource "aws_subnet" "public"{
    count = length(var.public_subnet_cidrs)

    vpc_id              = aws_vpc.main.id
    cidr_block          = var.public_subnet_cidrs[count.index]
    availability_zone   = element(var.azs, count.index)
    map_public_ip_on_launch = true

    tags = {

        Name = "${var.env}-public-subnet-${count.index + 1}"


    }
}

resource "aws_subnet" "private_app" {

    count = length(var.private_app_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_app_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]

    tags = {Name = "private-app-subnet-${count.index + 1}"}
}

resource "aws_subnet" "private_db"{

    count = length(var.private_db_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_db_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]

    tags = {Name = "private-db-subnet-${count.index + 1}"}

}

resource "aws_route_table" "public" {

    vpc_id = aws_vpc.main.id

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {Name = "public-rt"}
}

resource "aws_route_table_association" "public" {

    count = length(aws_subnet.public)
    subnet_id = aws_subnet.public[count.index].id

    route_table_id = aws_route_table.public.id


}

resource "aws_route_table" "private" {

    vpc_id = aws_vpc.main.id

    route {

        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id

    }

    tags = {Name = "private-rt"}

}

resource "aws_route_table_association" "private_app" {

    count = length(aws_subnet.private_app)
    subnet_id = aws_subnet.private_app[count.index].id

    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db"{

    count = length(aws_subnet.private_db)
    subnet_id = aws_subnet.private_db[count.index].id
    route_table_id = aws_route_table.private.id


}

### ALB용 보안 그룹 ###
resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-alb-sg"
  }
}

### RDS용 보안 그룹 ###
resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "Allow DB access from VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # 보안을 위해 EC2 SG를 지정하는 게 일반적이지만,
    # 여기선 예제로 VPC 내부 허용
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-rds-sg"
  }
}
