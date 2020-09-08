resource "aws_instance" "kube" {
  for_each = var.kube_names 
  ami           = var.install_image 
  instance_type = var.instance_type
  key_name = lookup(var.private_key, "name")
  vpc_security_group_ids = [aws_security_group.kube.id]
  subnet_id = aws_subnet.private.id
  private_ip = each.value
  root_block_device  {
    volume_type = "standard"
    volume_size = 24 
    delete_on_termination = true 
  } 
  tags = {
    Name = each.key
    component = var.sandbox_name
  }

  provisioner "file" {
    source = "id_rsa.pub"
    destination = "/tmp/id_rsa.pub"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
  }

  provisioner "file" {
    source = "kube_auth.sh"
    destination = "/tmp/kube_auth.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kube_auth.sh",
      format("%s %s", "sudo /tmp/kube_auth.sh", each.key)
    ]
  }
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
}

#resource "aws_route53_record" "kube" {
#  for_each = aws_instance.kube
#  zone_id = aws_route53_zone.sandbox.zone_id
#  name    = each.value.tags.Name
#  type    = "A"
#  ttl     = "30"
#
#  records = [
#    each.value.private_ip
#  ]
#}
