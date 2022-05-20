# VPC and security group
resource "random_shuffle" "az" {
  input = [
    "${var.region}a", 
    "${var.region}b", 
    "${var.region}c", 
    "${var.region}d", 
    "${var.region}e", 
    "${var.region}f"
  ]
  result_count = var.subnet_count
  seed = "hello"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.project_tag
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.project_tag
  }
}

resource "aws_subnet" "subnets" {
  depends_on = [aws_internet_gateway.gateway] 

  count = var.subnet_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = random_shuffle.az.result[count.index]

  tags = {
    Name = var.project_tag
  }
}

# EC2 Instances
resource "aws_instance" "instance" {
  count = var.rsk_node_cluster_size

  ami = var.ec2_ami_id
  instance_type = var.rsk_node_instance_type
  #key_name = var.key_pair_name

  root_block_device {
    volume_size = var.rsk_node_volume_size
  }

  tags = {
    Name = "rsk-node-${count.index}"
    Project = var.project_tag
  }
}

# Application Load Balancer
resource "aws_lb" "lb" {
  name = "rsk-nodes-alb"
  internal = false
  load_balancer_type = "application"
  # TODO: Might still need this for ingress reasons
  #security_groups = [security_group.lb_sg.id]
  subnets = [for subnet in aws_subnet.subnets: subnet.id]

  tags = {
    Project = var.project_tag
  }
}

resource "aws_alb_target_group" "alb_target_group" {  
  name = "rsk-node-rpc"  
  port = 4444
  protocol = "HTTP"  
  vpc_id = aws_vpc.vpc.id

  health_check {    
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    path = "/"
    port = 3001
  }

  tags = {
    Project = var.project_tag
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

# ECR Repository for Docker Images
resource "aws_ecr_repository" "ecr" {
  name                 = "tutorial-rsk-node"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Project = var.project_tag
  }
}
