module "pet-name" {
  source  = "app.terraform.io/mkdatz/pet-name/random"
  version = "~> 1.0.3"

  prefix = var.prefix
}
