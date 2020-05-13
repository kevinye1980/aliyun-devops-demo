provider "alicloud" {
  version    = "~> 1.82.0"
  region     = var.region
  assume_role {
    role_arn = "acs:ram::5326847730248958:role/TechnicalRole"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config-demo"
}

provider "helm" {
  version    = "~> 1.1.1"
  kubernetes {
    config_path = "~/.kube/config-demo"
  }
}

data "alicloud_account" "current" {
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-k8s-services"
    region   = "eu-central-1"
  }
}

module "external-dns" {
  source         = "../modules/external-dns"
  dns_ram_role   = "acs:ram::${data.alicloud_account.current.id}:role/dnsrole"
  domain_name    = "yagr.xyz"
  account_id     = data.alicloud_account.current.id
}
