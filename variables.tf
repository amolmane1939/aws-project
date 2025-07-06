variable "aws_region" {
    description = "The AWS region to deploy the resources"
    type        = string
    default     = "ap-south-1"
}

variable "github_repo_url" {
    description = "The URL of the GitHub repository to clone"
    type        = string
    default     = "https://github.com/amolmane1939/aws-project.git"
}