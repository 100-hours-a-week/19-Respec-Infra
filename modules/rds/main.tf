resources "aws_db_subnet_group" "this" {

    name = "${var.name} - subnet-group"
    subnet_ids = var.subnet_ids

    tags = {

        Name = "$(var.name)-subnet_group"
    }
}

resources "aws_db_instance" "this" {

    identifier = var.name
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    engine = var.engine
    engine_version = var.engine_version
    username = var.username
    password = var.password
    db_subnet_group_name = var.db_subnet_group_name
    vpc_security_group_ids = var.security_groups_ids
    multi_az = var.multi_az
    publicly_accessible = var.publicly_accessible
    skip_final_snapshot = true

    tags = var.tags

}