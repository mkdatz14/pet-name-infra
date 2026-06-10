module "pet-name" {
  source  = "app.terraform.io/mkdatz/pet-name/random"
  version = "0.0.0"

  prefix = var.prefix
}
