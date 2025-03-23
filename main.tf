provider "aws" {
  region = "ap-south-1"
 
}

# ------------------------------
# Generate Key Pair (CICD.pem)
# ------------------------------
resource "tls_private_key" "CICD_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "CICD_key" {
  key_name   = "CICD"
  public_key = tls_private_key.CICD_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.CICD_key.private_key_pem
  filename = "${path.module}/CICD.pem"
}

# Step 1: Create VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
        Name: "tf_vpc"
  }
}

# Step 1.1: Create Public & Private Subnets
resource "aws_subnet" "tf_pubsub" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "10.0.0.0/25"
  availability_zone = "ap-south-1a"
  tags = {
        Name: "pub_subnet"
  }
  map_public_ip_on_launch = true
}


# Step 1.2: Internet Gateway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
        Name: "tf_igw"
  }
}

# Step 1.3: Route Table for Public Subnet
resource "aws_route_table" "tf-pub_rt" {
  vpc_id = aws_vpc.tf_vpc.id
   tags = {
        Name: "tf-pub_rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.tf-pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.tf_pubsub.id
  route_table_id = aws_route_table.tf-pub_rt.id
}


# Step 2: Security Group for EC2
resource "aws_security_group" "tf_sg" {
  vpc_id = aws_vpc.tf_vpc.id
   tags = {
        Name: "tf_sgroup"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# ------------------------------
# Create EC2 Instance
# ------------------------------
resource "aws_instance" "Docker_server" {
  ami           = "ami-00bb6a80f01f03502"  # Update with the latest Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.tf_pubsub.id
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.tf_sg.id]  #  Use security group ID
  key_name      = aws_key_pair.CICD_key.key_name

  tags = {
    Name = "Docker Server"
  }
}


resource "aws_instance" "Jenkins_server" {
  ami           = "ami-00bb6a80f01f03502"  # Update with the latest Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.tf_pubsub.id
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.tf_sg.id]  #  Use security group ID
  key_name      = aws_key_pair.CICD_key.key_name

  tags = {
    Name = "Jenkins Server"
  }
}

