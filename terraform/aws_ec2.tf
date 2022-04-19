# Gets the latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Gets the default AWS VPC
data "aws_vpc" "default" {
  default = true
}

# Creates a security group which allows traffic on port 80 and 22
resource "aws_security_group" "allow_inbound" {
  name   = "allow_inbound"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Sets up an SSH key pair using existing SSH key on local machine
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/Users/stephengreer/.ssh/id_rsa.pub")
}

# Creates an AWS EC2 instance using the aws_vm_init.sh script to setup server
resource "aws_instance" "app_server_1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  user_data              = file("${path.module}/scripts/aws_vm_init.sh")
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]

  tags = {
    Name = "App Server 1"
  }
}
