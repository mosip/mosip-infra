variable "sandbox_name" {
  default = "sandbox1"
}

variable "region" {
  default = "ap-south-1"
}

variable "private_subnets" {
  type = list(string) 
  default = ["subnet_a"]

}
