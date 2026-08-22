terraform {
    backend "s3" {
        bucket = "test-run-tfstate-storage"
        key = "infra1/terraform.tfstate"
        region         = "ap-south-2"                          # Your AWS Region
        use_lockfile   = true                  # Matches DynamoDB table created above
        encrypt        = true
        kms_key_id   = "arn:aws:kms:ap-south-2:207791567608:alias/aws/s3" #dummy account
        profile      = "hi"
    }
}