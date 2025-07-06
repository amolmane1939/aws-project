#!/bin/bash

# Deploy CodeBuild Service Role with CloudFormation permissions
# This script creates the necessary IAM role and CodeBuild project

set -e

# Configuration
STACK_NAME="codebuild-service-role-stack"
TEMPLATE_FILE="cloudformation/codebuild-service-role.yaml"
REGION="ap-south-1"  # Based on your error message
ROLE_NAME="codebuild-service-role"
PROJECT_NAME="aws-project-build"

echo "🚀 Deploying CodeBuild Service Role with CloudFormation permissions..."
echo "Stack Name: $STACK_NAME"
echo "Template: $TEMPLATE_FILE"
echo "Region: $REGION"
echo "Role Name: $ROLE_NAME"
echo "Project Name: $PROJECT_NAME"
echo ""

# Check if AWS CLI is configured
echo "📋 Checking AWS CLI configuration..."
aws sts get-caller-identity --region $REGION

echo ""
echo "🔍 Validating CloudFormation template..."
aws cloudformation validate-template \
    --template-body file://$TEMPLATE_FILE \
    --region $REGION

echo ""
echo "🚀 Deploying CloudFormation stack..."
aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $STACK_NAME \
    --parameter-overrides \
        RoleName=$ROLE_NAME \
        ProjectName=$PROJECT_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --region $REGION \
    --no-fail-on-empty-changeset

echo ""
echo "✅ Deployment completed successfully!"

echo ""
echo "📊 Stack outputs:"
aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $REGION \
    --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
    --output table

echo ""
echo "🔧 Next steps:"
echo "1. Your CodeBuild service role now has the necessary CloudFormation permissions"
echo "2. You can now run your CodeBuild project to deploy CloudFormation templates"
echo "3. If you have an existing CodeBuild project, update it to use the new service role:"
echo "   Role ARN: $(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`CodeBuildServiceRoleArn`].OutputValue' --output text)"

echo ""
echo "🎉 Setup complete! Your CodeBuild project should now be able to deploy CloudFormation templates."
