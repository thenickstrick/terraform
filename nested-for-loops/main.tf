locals {
  raw_content = jsondecode(file("${path.module}/sample.json"))
}

output "raw_content" {
  value = local.raw_content
}
