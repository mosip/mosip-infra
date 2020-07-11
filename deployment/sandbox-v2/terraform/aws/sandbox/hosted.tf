resource "aws_route53_zone" "sandbox1" {
  name = "sb"
  vpc {
    vpc_id = aws_vpc.sandbox1.id
  } 

  tags = {
    Name = "sandbox1"
  }
}

resource "aws_route53_record" "sandbox-ns" {
  zone_id = aws_route53_zone.sandbox1.zone_id
  name    = "mzworker0"
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.mzworker0.private_ip
  ]

}
