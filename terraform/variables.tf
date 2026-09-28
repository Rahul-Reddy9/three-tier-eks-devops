variable "cluster_name" {
  type    = string
  default = "threetier-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.36"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "availability_zones" {
  type = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.36.0-eksbuild.25"
    },
    {
      name    = "vpc-cni"
      version = "v1.23.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.14.3-eksbuild.23"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.66.0-eksbuild.1"
    }
  ]
}