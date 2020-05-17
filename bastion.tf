module "bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 1.0"
  associate_public_ip_address = "true"

  name           = "${var.environment}-bastion-${local.user}"
  instance_count = 1

  ami                    = "${var.ec2_ami}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.generated_key.key_name}"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  subnet_ids             = ["${module.vpc.public_subnets}"]
}

resource "aws_security_group" "bastion-sg" {
  name   = "bastion-sg"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    cidr_blocks = [
      "${chomp(data.http.myip.body)}/32",
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "msql_bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${local.user}-${var.bastion_ssh_key_name}"
  public_key = "${tls_private_key.msql_bastion.public_key_openssh}"
}

resource "null_resource" "move_ssh_key" {
  depends_on = ["local_file.ssh_key_private"]

  provisioner "local-exec" {
    command = "mv ${local.user}-${var.bastion_ssh_key_name} ~/.ssh/${local.user}-${var.bastion_ssh_key_name} && chmod 600 ~/.ssh/${local.user}-${var.bastion_ssh_key_name}"
  }
}

resource "null_resource" "delete_ssh_key" {
  provisioner "local-exec" {
    when    = "destroy"
    command = "[ -e ~/.ssh/${local.user}-${var.bastion_ssh_key_name} ] && rm ~/.ssh/${local.user}-${var.bastion_ssh_key_name}"
  }
}

resource "local_file" "ssh_key_private" {
  depends_on        = ["tls_private_key.msql_bastion"]
  sensitive_content = "${tls_private_key.msql_bastion.private_key_pem}"
  filename          = "${local.user}-${var.bastion_ssh_key_name}"
}
