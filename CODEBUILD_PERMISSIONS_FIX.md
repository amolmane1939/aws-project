# CodeBuild Permissions Fix

## Problem
Your CodeBuild service role is missing the necessary CloudFormation permissions, causing this error:
```
An error occurred (AccessDenied) when calling the DescribeStacks operation: User: arn:aws:sts::600627315506:assumed-role/codebuild-service-role/AWSCodeBuild-a1f75a4c-a681-470b-85b0-12594708a115 is not authorized to perform: cloudformation:DescribeStacks on resource: arn:aws:cloudformation:ap-south-1:600627315506:stack/my-iam-role-stack/* because no identity-based policy allows the cloudformation:DescribeStacks action
```

## Solution Options

### Option 1: Deploy New CodeBuild Service Role (Recommended)

Use the provided CloudFormation template to create a new CodeBuild service role with all necessary permissions:

```bash
# Make the script executable
chmod +x deploy-codebuild-role.sh

# Deploy the new service role
./deploy-codebuild-role.sh
```

This will create:
- A new IAM role with CloudFormation and IAM permissions
- A new CodeBuild project configured with the correct role
- All necessary permissions for CloudFormation deployment

### Option 2: Update Existing Role Manually

If you prefer to update your existing role, add this IAM policy to your `codebuild-service-role`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStackResource",
                "cloudformation:GetTemplate",
                "cloudformation:ListStacks",
                "cloudformation:ListStackResources",
                "cloudformation:ValidateTemplate",
                "cloudformation:CreateChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:ListChangeSets"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:UpdateRole",
                "iam:PassRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:GetRolePolicy",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:ListRoleTags"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject",
                "s3:GetBucketVersioning"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        }
    ]
}
```

### Option 3: AWS CLI Commands

You can also add the policy using AWS CLI:

```bash
# Create the policy document
cat > codebuild-cloudformation-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:*",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:UpdateRole",
                "iam:PassRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:GetRolePolicy",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:ListRoleTags",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject",
                "s3:GetBucketVersioning",
                "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        }
    ]
}
EOF

# Attach the policy to your existing role
aws iam put-role-policy \
    --role-name codebuild-service-role \
    --policy-name CodeBuildCloudFormationPolicy \
    --policy-document file://codebuild-cloudformation-policy.json \
    --region ap-south-1
```

## Files Created

1. **`cloudformation/codebuild-service-role.yaml`** - CloudFormation template for the service role
2. **`deploy-codebuild-role.sh`** - Deployment script
3. **`CODEBUILD_PERMISSIONS_FIX.md`** - This documentation

## After Fixing Permissions

Once you've applied one of the solutions above, your CodeBuild project should be able to:
- ✅ Validate CloudFormation templates
- ✅ Deploy CloudFormation stacks
- ✅ Create and manage IAM roles
- ✅ Describe stack status and resources
- ✅ Handle stack updates and rollbacks

## Testing

After applying the fix, trigger your CodeBuild project again. The buildspec.yaml should now work correctly and deploy your CloudFormation template successfully.
