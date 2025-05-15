resources "aws_instance" "app" {

    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id  = var.subnet_id
    key_name = var.key_name

    tags = {
        
        Name = "${var.env}-app"

    }

    user_data = <<-EOF
            #!/bin/bash
              docker run -d -p 80:80 ${var.image}
              EOF
}