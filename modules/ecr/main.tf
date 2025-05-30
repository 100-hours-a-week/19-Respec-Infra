resource "aws_ecr_repository" "this" {

    name = var.repository_name
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {

        scan_on_push = var.scan_on_push

    }
    tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {

    repository = aws_ecr_repository.this.name

    policy = jsonencode({
        
        rules = [

            {

                rulePriority = 1
                description = "Expire untagged images older than 13 days"
                selection = {

                    tagStatus = "untagged"
                    countType = "sinceImagePushed"
                    countUnit = "days"
                    countNumber = 14

                }

                action = {
                    type = "expire"
                }


            }

        ]


    })

}