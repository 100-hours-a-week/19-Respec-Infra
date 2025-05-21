variable "name" {

    description = "The name of the ALB"
    type = string

}

variable "type" {

    description = "Load balancer type (applications, network, gateway)"
    type = string
    default = "application"

}

variable "subnets" {

    description = "List of subnets to attach the ALB"
    type = list(string)
}

variable "security_groups" {

    description = "Security groups to associate with ALB"
    type = list(string)

}

variable "internal" {


    description = "Is this an internal ALB"
    type = bool
    default = false

}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for ALB resources"
  type        = map(string)
}

variable "target_group_name" {
  description = "Name of target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for target group (HTTP/HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID for target group"
  type        = string
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "acm_certificate_arn" {
  description = "ACM에서 발급받은 인증서의 ARN"
  type        = string
}
