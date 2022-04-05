terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sameer-primary"

    workspaces {
      name = "image2pdf-prod"
    }
  }
}