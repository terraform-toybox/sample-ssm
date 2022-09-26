data "aws_ami" "ubuntu" {
  owners = ["099720109477"] # Canonical
  most_recent      = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

############
# Key Pair #
############
resource "aws_key_pair" "this" {
  key_name   = "kp-ssm-test"
  public_key = var.key_pair_public_key
}

################
# EC2 Instance #
################
resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  key_name = aws_key_pair.this.key_name

  subnet_id = aws_subnet.pri.id

  root_block_device {
    volume_type = "gp3"
    volume_size = "32"
  }

  tags = {
    Name = "ec2-ssm-test-pri"
  }
}
