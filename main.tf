# ---------------------------
# Networking Module
# ---------------------------
module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

# ---------------------------
# Security Group Module
# ---------------------------
module "security_group" {
  source = "./security_group"
  vpc_id = module.networking.vpc_id
}

# ---------------------------
# EC2 Module
# ---------------------------
module "jenkins_ec2" {
  source        = "./ec2"
  ec2_ami_id    = var.ec2_ami_id
  instance_type = "t2.medium"
  tag_name      = "terrafrom-testting-ec2"
  key_name      = var.key_name
  subnet_id     = module.networking.public_subnet_ids[0]  # first public subnet
  sg_ids        = [module.security_group.jenkins_sg_id]
  enable_public_ip = true
}
