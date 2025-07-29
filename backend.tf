terraform {
  backend "s3" {
    bucket = "week--7-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}
