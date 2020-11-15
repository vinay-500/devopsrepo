# Update EC2 as Route Record
# terraform import aws_route53_zone.route53-500apps-co-uk Z2485JN9ZJCGLG
/*resource "aws_route53_zone" "route53-500apps-co-uk" {
  name    = "500apps.co.uk"
  comment = "500apps UK server"
}*/

# terraform import aws_route53_zone.route53-500apps-io Z3SSVHJ2Y8RWOL
resource "aws_route53_zone" "route53-appup-ch" {
  name    = "appup.ch"
  comment = "Appup CH"
}

resource "aws_route53_zone" "private" {
  name    = "appup.local"
  comment = "Appup local "

  vpc {
    vpc_id = aws_vpc.vpc_appup.id
  }
}


