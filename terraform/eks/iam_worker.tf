resource "aws_iam_role" "eks_worker" {
  name               = "eks_worker-${module.label.id}"
  assume_role_policy = data.aws_iam_policy_document.eks_worker.json
}

data "aws_iam_policy_document" "eks_worker" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

# External DNS

resource "aws_iam_role_policy_attachment" "external_dns_change_record_sets" {
  policy_arn = aws_iam_policy.external_dns_change_record_sets.arn
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_policy" "external_dns_change_record_sets" {
  name   = "eks_worker-${module.label.id}-external_dns_change_record_sets"
  path   = "/"
  policy = "${data.aws_iam_policy_document.external_dns_change_record_sets.json}"
}

data "aws_iam_policy_document" "external_dns_change_record_sets" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "external_dns_list_record_sets" {
  policy_arn = aws_iam_policy.external_dns_list_record_sets.arn
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_policy" "external_dns_list_record_sets" {
  name   = "eks_worker-${module.label.id}-external_dns_list_record_sets"
  path   = "/"
  policy = "${data.aws_iam_policy_document.external_dns_list_record_sets.json}"
}

data "aws_iam_policy_document" "external_dns_list_record_sets" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks_worker.name}"
}

resource "aws_iam_instance_profile" "eks_worker" {
  name = "eks_worker-${module.label.id}"
  role = aws_iam_role.eks_worker.name
}
