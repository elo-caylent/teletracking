/*t
erraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-2"
}
*/