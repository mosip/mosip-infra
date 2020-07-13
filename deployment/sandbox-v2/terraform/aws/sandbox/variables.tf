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

variable "console_name" {
  default = "console"
}

variable "kube_names" {
   type = list(string)
   default = [
     "mzmaster",
     "mzworker0",
     "mzworker1",
     "mzworker2",
     "mzworker3",
     "mzworker4",
     "mzworker5",
     "mzworker6",
     "mzworker7",
     "mzworker8",
     "dmzmaster",
     "dmzworker0"
   ]
}

