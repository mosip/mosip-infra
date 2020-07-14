resource "aws_route53_zone" "sandbox" {
  name = "sb"
  vpc {
    vpc_id = aws_vpc.sandbox.id
  } 

  tags = {
    Name = var.sandbox_name 
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

resource "aws_route53_record" "kube" {
  for_each = aws_instance.kube
  zone_id = aws_route53_zone.sandbox.zone_id
  name    = each.value.tags.Name
  type    = "A"
  ttl     = "30"

  records = [
    each.value.private_ip
  ]
}

