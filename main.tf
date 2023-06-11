module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.0.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["one", "two"])

  name = "instance-${each.key}"

  instance_type = "t2.micro"
  monitoring    = true
  subnet_id     = module.vpc.public_subnets[0]
  ami           = var.ec2_ami

  ebs_block_device = [
    {
      device_name           = "/dev/sdf"
      volume_size           = 11
      volume_type           = "gp3"
      delete_on_termination = true
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "my-intuitive-s3-bucket-6a3f"
}
