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
  name    = "console"
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.console.private_ip
  ]
}

resource "aws_route53_record" "kube" {
  zone_id = aws_route53_zone.sandbox.zone_id
  name    = "mzworker0"
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.mzworker0.private_ip
  ]
}
