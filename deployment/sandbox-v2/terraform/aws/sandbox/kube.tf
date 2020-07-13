resource "aws_instance" "kube" {
  for_each = toset(var.kube_names) 
  ami           = "ami-0dd861ee19fd50a16"
  instance_type = "m5a.xlarge"
  key_name = "mosip-aws"
  security_groups = [aws_security_group.kube.id]
  subnet_id = tolist(data.aws_subnet_ids.private.ids)[0]
  root_block_device  {
    volume_type = "standard"
    volume_size = 24 
    delete_on_termination = true 
  } 
  tags = {
    Name = each.value 
    type = "kube" 
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
    source = "kube_auth.sh"
    destination = "/tmp/kube_auth.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kube_auth.sh",
      "sudo /tmp/kube_auth.sh"
    ]
  }
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
}

