
resource "aws_instance" "console" {
  ami           = var.install_image
  instance_type = var.instance_type
  key_name = var.key_name 
  vpc_security_group_ids = [aws_security_group.console.id]
  subnet_id = aws_subnet.private.id
  ebs_block_device  { /* 300 iops SSD */
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = 128
    delete_on_termination = true 
  } 

  tags = {
    Name = var.console_name 
    component = var.sandbox_name
  }

  provisioner "file" {
    source = "id_rsa.pub"
    destination = "/tmp/id_rsa.pub"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
  }

  provisioner "file" {
    source = "id_rsa"
    destination = "/tmp/id_rsa"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
  }

  provisioner "file" {
    source = "console_auth.sh"
    destination = "/tmp/console_auth.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/console_auth.sh",
      "sudo /tmp/console_auth.sh"
    ]
  }
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
}

resource "aws_route53_record" "console" {
  zone_id = aws_route53_zone.sandbox.zone_id
  name    = aws_instance.console.tags.Name
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.console.private_ip
  ]
}
