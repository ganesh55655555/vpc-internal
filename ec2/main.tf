# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "jenkins_ec2" {
  ami                    = var.ec2_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id                       # Subnet from networking module
  vpc_security_group_ids = var.sg_ids                           # Security groups from SG module
  key_name               = var.key_name                         # Existing AWS key pair
  associate_public_ip_address = var.enable_public_ip

  tags = {
    Name = var.tag_name
  }

}
