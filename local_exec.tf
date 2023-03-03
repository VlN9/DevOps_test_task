resource "null_resource" "add_inventory" {
  provisioner "local-exec" {
    command = "echo \"[wordpress_server]\n${aws_instance.this.public_ip}\" > ./ansible/hosts.txt" 
  }

  depends_on = [
    aws_instance.this
  ]
}

resource "null_resource" "run_playbook" {
  provisioner "local-exec" {
    command = "sleep 3 && ansible-playbook ./ansible/installation.yaml --extra-vars \"db_endpoint=${aws_db_instance.this.address} db_password=${data.aws_ssm_parameter.rds_pwd.value}\""
  }

  depends_on = [
    null_resource.add_inventory
  ]
}