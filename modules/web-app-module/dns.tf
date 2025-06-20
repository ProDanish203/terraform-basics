# resource "aws_route53_zone" "primary" {
#   count = var.create_dns_zone ? 1 : 0
#   name  = var.domain_name
# }

# data "aws_route53_zone" "primary" {
#   count = var.create_dns_zone ? 0 : 1
#   name  = var.domain_name
# }

# locals {
#   dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
#   subdomain   = var.environment == "production" ? "" : "${var.environment}."
# }

# resource "aws_route53_record" "root" {
#   zone_id = local.dns_zone_id
#   name    = "${local.subdomain}${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = aws_lb.load_balancer.dns_name
#     zone_id                = aws_lb.load_balancer.zone_id
#     evaluate_target_health = true
#   }
# }
