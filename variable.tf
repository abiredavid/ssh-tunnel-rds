variable "vpccidr" {
  description = "CIDR for VPC"
  default     = "10.80.0.0/16"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "db_instance_type" {
  description = "Type of the instance used for the database"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database created"
  default     = "testdb"
}

variable "db_user" {
  description = "username for the database"
  default     = "root"
}

variable "db_pass" {
  description = "password for the database"
  default     = ""
}

variable "default_character_set" {
  description = "Default Character Set encoding"
  default     = "utf8"
}

variable "default_collation" {
  description = "Default Collation Set encoding"
  default     = "utf8_unicode_ci"
}

variable "default_storage" {
  description = "Amount of storage to be allocated for the DB instance in GB"
  default     = "5"
}

variable "environment" {
  description = "Variable for storing environment."
  default     = "dev"
}

variable "bastion_ssh_key_name" {
  description = "SSH key to add to the bastion host"
  default     = "bastion"
}

variable "ec2_ami" {
  description = "AMI to use for bastion host"
  default     = "ami-0323c3dd2da7fb37d"
}
