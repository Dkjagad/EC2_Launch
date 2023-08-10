#Configure the AWS Provider
provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}
#Create EC2 Instance
resource "aws_instance" "instance281" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jsg2.id]
  tags = {
    Name = "myproject111"
  }

  #Bootstrap Jenkins installation and start  
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum upgrade
  amazon-linux-extras install epel -y
  sudo dnf install java-11-amazon-corretto -y
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF

  user_data_replace_on_change = true
}

#Create Security group
resource "aws_security_group" "jsg2" {
  name        = "jsg2"
  description = "Jenkins Security Group"

  #Allow Inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow Inbound HTTP
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

#S3 Bucket
/*resource "aws_s3_bucket" "jenkins-artifacts1" {
  bucket = "week20projectjenkins1234"
}

resource "aws_s3_bucket_ownership_controls" "jenkins_ownership" {
  bucket = aws_s3_bucket.jenkins-artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "privates3bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.jenkins_ownership]

  bucket = aws_s3_bucket.jenkins-artifacts.id
  acl    = "private"
}*/
