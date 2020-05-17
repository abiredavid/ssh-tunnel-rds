output "aurora_endpoint" {
  description = "The aurora database endpoint"
  value       = "${module.aurora.this_rds_cluster_endpoint}"
}

output "username" {
  description = "Database username"
  value = "${module.aurora.this_rds_cluster_master_username}"
}

output "password" {
  description = "Database password"
  value = "${module.aurora.this_rds_cluster_master_password}"
}

output "bastion_public_dns" {
  description = "Bastion host public dns"
  value = "${module.bastion.public_dns[0]}"
}

output "tunnel_setup_command" {
  description = "Command you need to run to run to set up the tunnel"
  value = "ssh -i ~/.ssh/${local.user}-${var.bastion_ssh_key_name} -l ec2-user -N -L 3306:${module.aurora.this_rds_cluster_endpoint}:3306 ${module.bastion.public_dns[0]}"
}

output "mysql_connection_command" {
  description = "Command you can run to access the MySQL db directly"
  value = "mysql -h host.docker.internal -P 3306 -u${module.aurora.this_rds_cluster_master_username} -p${module.aurora.this_rds_cluster_master_password}"
}
