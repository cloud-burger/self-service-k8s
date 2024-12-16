resource "aws_iam_role" "eks_role" {
  name = "eks_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ],
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Effect = "Allow"
      },
      {
        Action = [
          "sts:AssumeRole"
        ],
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}
