data "aws_route53_zone" "scalac_io" {
  name = "scalac.io."
}

resource "aws_route53_record" "cnames" {
  for_each = local.cnames

  zone_id = data.aws_route53_zone.scalac_io.zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = "900"
  records = [each.value]
}
