# Networking
vpc_cidr             = "11.0.0.0/16"
vpc_name             = "testing-terraform-vpc"
cidr_public_subnet   = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
cidr_private_subnet  = ["11.0.4.0/24", "11.0.5.0/24", "11.0.6.0/24"]
eu_availability_zone = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

# EC2
ec2_ami_id = "ami-02b8269d5e85954ef"
key_name   = "terrafrom-testing"   # Replace with the key you created in AWS
