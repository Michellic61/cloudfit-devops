data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "cloudfit-web-sg"
  description = "Allow HTTP inbound"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.sg_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudfit-web-sg"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -eux
              dnf -y update
              dnf -y install python3 python3-pip
              pip3 install flask
              cat >/opt/app.py <<'PY'
              from flask import Flask, jsonify
              app = Flask(__name__)
              @app.route("/status")
              def status():
                  return jsonify({"status":"ok"})
              @app.route("/")
              def root():
                  return "CloudFit API running"
              if __name__ == "__main__":
                  app.run(host="0.0.0.0", port=80)
              PY
              nohup python3 /opt/app.py &
              EOF

  tags = {
    Name = "cloudfit-web"
  }
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "optional" {
  count = var.create_bucket ? 1 : 0

  bucket = "cloudfit-devops-${random_id.suffix.hex}"
  tags = {
    Name = "cloudfit-devops-bucket"
  }
}
