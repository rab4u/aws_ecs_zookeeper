# CREATING TRUST POLICY FOR ECS AND EC2
data aws_iam_policy_document module-trust-policy-document{
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

# CREATING IAM ROLE
resource "aws_iam_role" "module-service-role" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.module-trust-policy-document.json
  tags = var.tags
}

# CREATE AND ADD INSTANCE PROFILE
resource "aws_iam_instance_profile" "module-instance-profile" {
  name = var.name
  role = aws_iam_role.module-service-role.name
}

data aws_iam_policy_document module-policy-document{
  dynamic statement{
    for_each = var.iam_policy_statements
    content {
      effect = statement.value["effect"]
      actions = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }
}

# ADDING INLINE POLICY TO THE ROLE
resource "aws_iam_role_policy" module-policy {
  name = var.name
  role = aws_iam_role.module-service-role.id
  policy = data.aws_iam_policy_document.module-policy-document.json
}

resource "aws_iam_role_policy_attachment" "additional_policies" {
  count      = length(var.policies)
  policy_arn = element(var.policies, count.index)
  role       = aws_iam_role.module-service-role.name
}

resource "aws_iam_role_policy_attachment" "default_policies" {
  count      = length(var.default_policies)
  policy_arn = element(var.default_policies, count.index)
  role       = aws_iam_role.module-service-role.name
}

