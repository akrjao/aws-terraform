variable "aws_region" {
  type = object({
    code = string
    availability_zone_a = string
    availability_zone_b = string 
    default = bool 
    ami = string 
    instance_type = string 
  })
}