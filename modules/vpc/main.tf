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
    tags = [name = "main-nat"]

}

resource "aws_eip" "nat"{

    domain = "vpc"
}

resource "aws-subnet" "public"{
    count = length(var.public_subnet_cidrs)

    vpc_id              = aws_vpc.main.vpc_id
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

resource "aws_route_table_association" "private_db{

    count = length(aws_subnet.private_db)
    subnet_id = aws_subnet.private_db[count.index].id
    route_table_id = aws_route_table.private.identifier


}