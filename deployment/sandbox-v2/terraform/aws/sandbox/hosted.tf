resource "aws_route53_zone" "sandbox" {
  name = "sb"
  vpc {
    vpc_id = aws_vpc.sandbox.id
  } 

  tags = {
    Name = "sandbox"
  }
}

resource "aws_route53_record" "console" {
  zone_id = aws_route53_zone.sandbox.zone_id
  name    = var.console_name
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.console.private_ip
  ]
}

data "aws_instances" "kube_instances" {
  instance_tags =  {
    type = "kube"
  }
}

data "aws_instance" "kube_instance" {
  for_each = toset(data.aws_instances.kube_instances.ids)
  instance_id = each.value
}

resource "aws_route53_record" "kube" {
  for_each = data.aws_instance.kube_instance
  zone_id = aws_route53_zone.sandbox.zone_id
  name    = each.value.tags.Name
  type    = "A"
  ttl     = "30"

  records = [
    each.value.private_ip
  ]
}
