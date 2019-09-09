resource "aws_eks_cluster" "cloudlad" {
  name                      = module.label.id
  role_arn                  = aws_iam_role.eks-master.arn
  enabled_cluster_log_types = local.enabled_cluster_log_types

  vpc_config {
    security_group_ids = [aws_security_group.eks-master.id]
    subnet_ids         = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role.eks-master,
    aws_iam_role_policy_attachment.eks-master-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-master-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.cloudlad,
  ]
}
