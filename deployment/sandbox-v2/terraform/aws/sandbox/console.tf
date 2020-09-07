
resource "aws_instance" "console" {
  ami           = var.install_image
  instance_type = var.instance_type
  key_name = lookup(var.private_key, "name")
  vpc_security_group_ids = [aws_security_group.console.id]
  subnet_id = aws_subnet.private.id
  private_ip = lookup(var.console_name, "private_ip")
  root_block_device  {
    volume_type = "standard"
    volume_size = 24
    delete_on_termination = true 
  } 
  ebs_block_device  { /* 300 iops SSD */
    device_name = "/dev/sdf"
    volume_type = "gp2" // Set "io1" for provisioned SSD
    /* iops = 384 */  // Only valid for volume_type = io1
    volume_size = 128
    delete_on_termination = true 
  } 

  tags = {
    Name = lookup(var.console_name, "name")
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
    source = "id_rsa"
    destination = "/tmp/id_rsa"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
  }

  provisioner "file" {
    source = "console_auth.sh"
    destination = "/tmp/console_auth.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/console_auth.sh",
      format("%s %s", "sudo /tmp/console_auth.sh", lookup(var.console_name, "name"))
    ]
  }
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file(lookup(var.private_key, "local_path"))
    }
}

#resource "aws_route53_record" "console" {
#  zone_id = aws_route53_zone.sandbox.zone_id
#  name    = aws_instance.console.tags.Name
#  type    = "A"
#  ttl     = "30"
#
#  records = [
#    aws_instance.console.private_ip
#  ]
#}
