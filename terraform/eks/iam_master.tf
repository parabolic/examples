resource "aws_iam_role" "eks-master" {
  name               = "eks-master-${module.label.id}"
  assume_role_policy = data.aws_iam_policy_document.eks-master.json
}

data "aws_iam_policy_document" "eks-master" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    effect = "Allow"
  }
}
resource "aws_iam_role_policy_attachment" "eks-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-master.name}"
}

resource "aws_iam_role_policy_attachment" "eks-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-master.name}"
}
