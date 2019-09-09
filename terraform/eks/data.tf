data "aws_region" "current" {}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.cloudlad.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "template_file" "eks_worker" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars = {
    eks_cluster_endpoint  = aws_eks_cluster.cloudlad.endpoint
    certificate_authority = aws_eks_cluster.cloudlad.certificate_authority.0.data
    cluster_name          = module.label.id
  }
}
