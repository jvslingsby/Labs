#-----compute/variables.tf-----
#===============================
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key_public" {
  type    = string
  #Replace this with the location of your public key .pub
  default = "C:\\Users\\JV Slingsby\\.ssh\\id_rsa.pub"
}

variable "ssh_key_private" {
  type    = string
  #Replace this with the location of your private key
  default = "C:\\Users\\JV Slingsby\\.ssh\\id_rsa"
}

variable "subnet_ips" {}

variable "security_group" {}

variable "subnets" {}
