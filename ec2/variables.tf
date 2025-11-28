variable "ec2_ami_id" {}
variable "instance_type" {
  default = "t2.medium"
}
variable "tag_name" {
  default = "Jenkins:Ubuntu Linux EC2"
}
variable "subnet_id" {}
variable "sg_ids" {
  type = list(string)
}
variable "key_name" {}
variable "enable_public_ip" {
  type    = bool
  default = true
}
variable "user_data" {
  type    = string
  default = ""
}
