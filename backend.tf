terraform {
    backend "s3" {
        bucket = "manual-task1-tfstate-687078156188-us-east-1"
        key = "manual-task1/terraform.tfstate"
        region = "us-east-1"
        use_lockfile = true
    }
}