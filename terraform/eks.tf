module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_private_access = true
  endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  addons = {
    coredns = {
      addon_version = "v1.14.3-eksbuild.23"
    }

    kube-proxy = {
      addon_version = "v1.36.0-eksbuild.25"
    }

    vpc-cni = {
      addon_version  = "v1.23.1-eksbuild.1"
      before_compute = true
    }

    aws-ebs-csi-driver = {
      addon_version            = "v1.66.0-eksbuild.1"
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 3

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
    }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 3

      labels = {
        role = "spot"
      }

      taints = {
        market = {
          key    = "market"
          value  = "spot"
          effect = "NO_SCHEDULE"
        }
      }

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
      disk_size      = 50
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "dev"
    Project     = "three-tier-eks"
  }
}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

provider "kubernetes" {
  host = data.aws_eks_cluster.default.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.default.certificate_authority[0].data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.default.name
    ]

    command = "aws"
  }
}