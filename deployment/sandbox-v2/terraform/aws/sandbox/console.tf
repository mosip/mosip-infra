
resource "aws_instance" "console" {
  ami           = "ami-0dd861ee19fd50a16"
  instance_type = "m5a.xlarge"
  key_name = "mosip-aws"
  vpc_security_group_ids = [aws_security_group.console.id]
  //subnet_id = tolist(data.aws_subnet_ids.private.ids)[0] // TODO: Causes replacement of instance everytime.
  ebs_block_device  {
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = 128
    delete_on_termination = true 
  } 

  tags = {
    Name = var.console_name 
    component = "sandbox"
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
