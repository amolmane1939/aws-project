
resource "aws_iam_role" "codebuild_role" {
    name = "codebuild-service-role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "codebuild.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_role_policy" "codebuild_attach" {
    role = aws_iam_role.codebuild_role.name
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Sid      = "CodeBuildAccess"
        Effect   = "Allow"
        Action   = ["codebuild:*"]
        Resource = "*"
    },
    {
        Sid      = "CloudWatchAccess"
        Effect   = "Allow"
        Action   = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        Resource = "*"
    },
    {
        Sid      = "CloudFormationAccess"
        "Effect": "Allow",
        "Action": [
        "cloudformation:ValidateTemplate"
        ],
        "Resource": "*"
    }
    ]
  })
}

resource "aws_codebuild_project" "project" {
    name = "MyAutoCodeBuildProject"
    description = "This is my auto codebuild project"
    service_role = aws_iam_role.codebuild_role.arn

    source {
        type = "GITHUB"
        location = var.github_repo_url
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:7.0"
        type = "LINUX_CONTAINER"
        privileged_mode = false
    }
    artifacts {
        type = "NO_ARTIFACTS"
    }
}