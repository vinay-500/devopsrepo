# Repository for creating our docker files
resource "aws_ecr_repository" "ecr_appup" {
  name = "appup"
}

output "register_url" {
  value       = "${aws_ecr_repository.ecr_appup.repository_url}"
  description = "Container Registry URL"
}
