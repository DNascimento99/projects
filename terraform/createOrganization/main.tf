terraform {
  backend "s3" {
    bucket = "bucket-tf-state-projeto-devops"
    key    = "terraform.tf.state"
    region = "us-east-1"
  }
}
module "organization" {
  source = "./modules/organization"
}
module "identitycenter" {
  source = "./modules/identytyCenter"
}
module "scp" {
  source     = "./modules/scp"
  depends_on = [module.organization]
}