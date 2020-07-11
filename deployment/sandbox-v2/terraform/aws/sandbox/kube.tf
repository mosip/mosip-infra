resource "aws_instance" "mzworker0" {
  ami           = "ami-0dd861ee19fd50a16"
  instance_type = "m5a.xlarge"
  key_name = "mosip-aws"
  security_groups = ["kubeMachines"]
  root_block_device  {
    volume_type = "standard"
    volume_size = 24 
    delete_on_termination = true 
  } 
  tags = {
    Name = "mzworker0"
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
    source = "auth.sh"
    destination = "/tmp/auth.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/auth.sh",
      "sudo /tmp/auth.sh"
    ]
  }
    connection {
      type     = "ssh"
      user     = "centos"
      host     =  self.public_ip
      private_key = file("/home/mosipuser/.ssh/mosip-aws.pem")
    }
}
