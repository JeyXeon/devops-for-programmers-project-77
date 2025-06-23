terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-d"
  service_account_key_file = var.yc_sa_key_file
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
