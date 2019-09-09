resource "aws_security_group" "eks-master" {
  name        = "eks-master-{module.label.id}"
  description = "Security group for the eks master"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

resource "aws_security_group_rule" "local_workstation_ip" {
  cidr_blocks       = local.allowed_ips
  description       = "Allow the local workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-master.id}"
  to_port           = 443
  type              = "ingress"
}


resource "aws_security_group" "eks_workers" {
  name        = "eks_worker-${module.label.id}"
  description = "Security group for all the worker nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label_owned.tags
}
resource "aws_security_group_rule" "eks_worker-ingress-ssh" {
  description       = "Allow the operator to be able to connect to the worker nodes via ssh"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks_workers.id}"
  cidr_blocks       = local.allowed_ips
  to_port           = 22
  type              = "ingress"
}
resource "aws_security_group_rule" "eks_worker-ingress-self" {
  description              = "Allow worker nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_workers.id}"
  source_security_group_id = "${aws_security_group.eks_workers.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_worker-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_workers.id}"
  source_security_group_id = "${aws_security_group.eks-master.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-master-ingress-worker-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-master.id}"
  source_security_group_id = "${aws_security_group.eks_workers.id}"
  to_port                  = 443
  type                     = "ingress"
}
