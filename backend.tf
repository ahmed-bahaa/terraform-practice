terraform{
    required_version = ">=0.12.0"
    backend "s3" {
        profile = "default"
        bucket = "bahaa-terraform"
        key    = "terraformStateFile"
        region = "us-east-1"

    }
}