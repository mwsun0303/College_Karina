# 1.Provider 선언
terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region  = "ap-northeast-2"
  profile = "admin"
}

# 2.VPC, Subnet
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 5.0"
  name            = "college-vpc"
  cidr            = "192.168.0.0/16"
  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
  public_subnets  = ["192.168.10.0/24", "192.168.20.0/24"]
}

# 3.EFS 생성
resource "aws_efs_file_system" "college-log-efs" {
  creation_token = "college-product"
  encrypted = true

  tags = {
    Name = "college-Prometheus-Monitoring-Log"
  }
}

# 4.EKS Worker Node 역할 정의
resource "aws_iam_role" "efs_worker_node_role" {
  name = "EFS-Worker-Node-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole",
    }],
  })
}

# 4-1.정책 생성
resource "aws_iam_policy" "efs_readwrite_policy" { // EFS 사용 권한
  name        = "AmazonElasticFileSystemReadWriteAccess"
  description = "Provides read and write access to Amazon EFS resources"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:Describe*",
        "elasticfilesystem:List*",
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientAccess",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:DescribeLifecycleConfiguration",
        "elasticfilesystem:PutLifecycleConfiguration"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateFileSystem",
        "elasticfilesystem:DeleteFileSystem",
        "elasticfilesystem:UpdateFileSystem",
        "elasticfilesystem:CreateMountTarget",
        "elasticfilesystem:DeleteMountTarget",
        "elasticfilesystem:UpdateMountTargetSecurityGroups",
        "elasticfilesystem:CreateTags",
        "elasticfilesystem:DeleteTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# 4-2. 정책 역할 연결
resource "aws_iam_role_policy_attachment" "efs_worker_node_policy_attachment" {
  policy_arn = aws_iam_policy.efs_readwrite_policy.arn
  role       = aws_iam_role.efs_worker_node_role.name

}

# 4-3.Mount Target 설정
resource "aws_efs_mount_target" "Prometheus_2a" {
  file_system_id  = aws_efs_file_system.college-log-efs.id
  subnet_id       = module.vpc.private_subnets[0] # ap-northeast-2a
  security_groups = [module.NAT_SG.security_group_id]

}
resource "aws_efs_mount_target" "Prometheus_2c" {
  file_system_id  = aws_efs_file_system.college-log-efs.id
  subnet_id       = module.vpc.private_subnets[1] # ap-northeast-2c
  security_groups = [module.NAT_SG.security_group_id]
}

# 5. EKS 생성
module "eks" {
  source  = "terraform-aws-modules/eks/aws"    # 외부 모듈을 사용하여 생성
  version = "~> 19.0"

  # 5-1.EKS Cluster Setting
  cluster_name    = "college-eks"              # EKS 이름
  cluster_version = "1.29"                     # Version
  vpc_id          = module.vpc.vpc_id # VPC
  subnet_ids      = module.vpc.private_subnets # Subnet

  # 5-2.OIDC(OpenID Connect) 구성 
  enable_irsa = true

  # 5-3.EKS Worker Node 정의 ( ManagedNode방식 / Launch Template 자동 구성 )
  eks_managed_node_groups = {
    college_WorkerNode = {                      # WorkerNode 정의
      instance_types = ["t3.medium"]             # instance 사양, 범위
      min_size       = 1                        # 최소
      max_size       = 2                        # 최대
      desired_size   = 1                        
      vpc_security_group_ids = [module.add_node_sg.security_group_id]
      iam_instance_profile_name = aws_iam_policy.efs_readwrite_policy.name # 추가
      efs = true # 추가

    }
  }

  # 5-4.public-subnet(bastion)과 API와 통신하기 위해 설정(443)
  cluster_additional_security_group_ids = [module.add_cluster_sg.security_group_id] 
  cluster_endpoint_public_access        = true

  # K8s ConfigMap Object "aws_auth" IRSA 구성 
  manage_aws_auth_configmap = true
  aws_auth_users = [                # aws의 해당 계정 IAM 권한을 Container의 Account user/admin/으로 Mapping 
    {
      userarn  = "arn:aws:iam::${data.aws_iam_user.EKS_Admin_ID.id}:user/admin"
      username = "admin"            # Account의 사용자 명
      groups   = ["system:masters"]
    },
  ]
}

# 6.kubernetes provider 선언
# kubernetes에서 사용할 token을 비롯한 사용자 admin의 Account 인증 데이터를 가져옴
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
     # eks cluster의 Account (admin profile)의 Account 정보 (token)를 가져옴
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--profile", "admin"]
    
  }
}
# 5.Kubernetes Account와 연결할 AWS 계정
data "aws_iam_user" "EKS_Admin_ID" {
  user_name = "Sun_user"
}

# 7.보안그룹
# 7-1. cluster 보안그룹
module "add_cluster_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 5.0"
  name        = "add_cluster_sg"
  description = "add_cluster_sg"

  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# 7-2. Worker Node 보안그룹
module "add_node_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 5.0"
  name        = "add_node_sg"
  description = "add_node_sg"

  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# 7-3. Bastion 보안그룹
module "BastionHost_SG" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "~> 5.0"
  name            = "BastionHost_SG"
  description     = "BastionHost_SG"
  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# 7-4. Public 보안그룹
module "Public_SG" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "~> 5.0"
  name            = "Public_SG"
  description     = "Public_SG"
  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# 7-5.Nat 보안그룹
module "NAT_SG" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "~> 5.0"
  name            = "NAT_SG"
  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks[0]
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks[1]
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# 7-6. DB 보안그룹
module "DB_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 5.0"
  name        = "DB_sg"
  description = "DB_sg"

  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# 8.ec2 Key-pair
data "aws_key_pair" "ec2-key" {
  key_name = "WebServer"
}


# 9.EC2 생성
# 9-1.Bastion
resource "aws_instance" "BastionHost" {
  ami                         = "ami-0bc4327f3aabf5b71"
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.ec2-key.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.BastionHost_SG.security_group_id]

  tags = {
    Name = "BastionHost_Instance"
  }
}

# 9-2.NAT
resource "aws_instance" "nat_ec2" {
  ami                         = "ami-0f4c2e6aee30ccae8"
  subnet_id                   = module.vpc.public_subnets[1]
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.ec2-key.key_name
  source_dest_check           = false
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.NAT_SG.security_group_id]
  tags = {
    Name = "nat-ec2"
  }
}

# 10.라우팅 테이블
# 10-1.Private Routing Table
# Private Subnet Routing Table ( dest: NAT Instance ENI )
data "aws_route_table" "private_0" {
  subnet_id  = module.vpc.private_subnets[0]
  depends_on = [module.vpc]
}

data "aws_route_table" "private_1" {
  subnet_id  = module.vpc.private_subnets[1]
  depends_on = [module.vpc]
}

resource "aws_route" "private_subnet_0" {
  route_table_id         = data.aws_route_table.private_0.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_ec2.primary_network_interface_id
  depends_on             = [module.vpc, aws_instance.nat_ec2]
}

resource "aws_route" "private_subnet_1" {
  route_table_id         = data.aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_ec2.primary_network_interface_id
  depends_on             = [module.vpc, aws_instance.nat_ec2]
}

// Private Subnet Tag ( AWS Load Balancer Controller Tag / internal )
resource "aws_ec2_tag" "private_subnet_tag1" {
  resource_id = module.vpc.private_subnets[0]
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
resource "aws_ec2_tag" "private_subnet_tag2" {
  resource_id = module.vpc.private_subnets[1]
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

// Public Subnet Tag ( AWS Load Balancer Controller Tag / internet-facing )
resource "aws_ec2_tag" "public_subnet_tag1" {
  resource_id = module.vpc.public_subnets[0]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}
resource "aws_ec2_tag" "public_subnet_tag2" {
  resource_id = module.vpc.public_subnets[1]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

output "bastion_ip" {
  value       = aws_instance.BastionHost.public_ip
  description = "bastion-host public IP"
}

 10. Bastion AutoScaling
 resource "aws_launch_template" "bastion-Template" {
  
   name_prefix   = "college-as"
   image_id      = "ami-057ec42830b20bc2c"
   instance_type = "t2.micro"
   key_name = "project_key"
  
   network_interfaces {
     associate_public_ip_address = true
   }

 }

 resource "aws_autoscaling_group" "college-autoscaling" {
   vpc_zone_identifier = [module.vpc.public_subnets[0],module.vpc.public_subnets[1]]
   desired_capacity   = 1
   max_size           = 2
   min_size           = 1
  
   launch_template {
     id      = aws_launch_template.bastion-Template.id
     version = "$Latest"
    
  
   }

   tag {
     key                 = "Name"
     value               = "AS-Bastion"
     propagate_at_launch = true
   }

 }

# 11.DB Subnet Group
resource "aws_db_subnet_group" "college-db-subnet-group" {
  name       = "main"
  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1] ]

  tags = {
    Name = "college-db-subnet-group"
  }
} 