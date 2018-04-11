provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.14"
}

provider "template" {
  version = "~> 1.0"
}

data "aws_ami" "rock" {
  most_recent = true

  filter {
    name = "name"

    # Maybe we should rename the AMI to `juxt-rock`?
    values = ["juxt-arch-*"]
  }

  owners = ["375332021361"]
}

data "template_file" "user_data" {
  template = "${file("${path.cwd}/rock.sh")}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic."

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name   = "allow_all"
    Source = "juxt/rock"
  }
}

resource "aws_instance" "rock" {
  ami               = "${data.aws_ami.rock.id}"
  instance_type     = "t2.small"
  availability_zone = "eu-west-1"
  security_groups   = ["${aws_security_group.allow_all.id}"]
  user_data         = "${data.template_file.user_data.rendered}"

  # This needs to be created manually.
  key_name = "rock"

  root_block_device {
    volume_size = 20
  }

  tags {
    Name   = "rock"
    Source = "juxt/rock"
  }
}
