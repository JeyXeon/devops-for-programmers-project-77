terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://hb.ru-msk.vkcloud-storage.ru"
    }

    bucket     = "mityanedima-terraform-bucket"
    key        = "terraform.tfstate"
    region     = "RegionOne"
    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
  }
}
