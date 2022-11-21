provider "aws" {
  region = var.region
}

# terraform {
#   backend "s3" {
#     bucket = "YOUR_BUCKET_NAME"
#     key = "layer2/infrastructure.tfstate"
#     region = "us-east-1"
#   }
# }
