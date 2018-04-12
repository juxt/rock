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

    values = ["juxt-rock-*"]
  }

  owners = ["639331413963"]
}

data "template_file" "user_data" {
  template = "${file("${path.cwd}/rock.sh")}"
}

resource "aws_cloudwatch_log_group" "rock" {
  name              = "rock"
  retention_in_days = 7
}

resource "aws_iam_role" "rock" {
  name = "rock_instance_profile"
  path = "/"

  assume_role_policy = "${file("assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "rock" {
  name = "rock_instance_profile"
  role = "${aws_iam_role.rock.name}"
}

resource "aws_iam_role_policy" "rock" {
  name   = "rock_logs"
  role   = "${aws_iam_role.rock.id}"
  policy = "${file("policy.json")}"
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

  egress {
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
  ami                  = "${data.aws_ami.rock.id}"
  instance_type        = "t2.small"
  availability_zone    = "eu-west-1a"
  iam_instance_profile = "${aws_iam_instance_profile.rock.name}"
  security_groups      = ["${aws_security_group.allow_all.name}"]
  user_data            = "${data.template_file.user_data.rendered}"

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

output "address" {
  value = "${aws_instance.rock.public_dns}"
}
