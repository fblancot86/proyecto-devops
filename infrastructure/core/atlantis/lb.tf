# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER
# ------------------------------------------------------------------------------

resource "aws_lb" "load_balancer" {
  name = "elb-${var.environment}-${var.region}-${var.function}-${var.sequence}"
  # Cannot be longer than 32 characters
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups = [module.atlantis_cluster.security_group_id]
  subnets = [
    data.aws_subnet.eu-central-1-1a.id,
    data.aws_subnet.eu-central-1-1b.id,
    data.aws_subnet.eu-central-1-1c.id,
  ]

  #enable_deletion_protection = var.enable_deletion_protection
  enable_deletion_protection = false

  /*access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }*/

  /*tags = [
    var.tags
  ]*/

  tags = {
    Name        = "elb-${var.environment}-${var.region}-${var.function}-${var.sequence}"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
    Service     = var.service
  }
  depends_on = [module.atlantis_cluster]
}

resource "aws_lb_target_group" "atlantis_target" {
  name        = "tg-${var.environment}-${var.region}-${var.function}-${var.sequence}"
  port        = var.target-port
  protocol    = var.target-protocol
  target_type = var.target-type
  vpc_id      = var.vpc_id

  depends_on = [module.atlantis_cluster]
}

resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port     = 80
  protocol = var.listener-protocol
  default_action {
    type             = var.listener-default-action-type
    target_group_arn = aws_lb_target_group.atlantis_target.arn
  }
  depends_on = [
    module.atlantis_cluster, aws_lb_target_group.atlantis_target
  ]
}

resource "aws_lb_listener" "front_end_4141" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 4141
  protocol          = var.listener-protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atlantis_target.arn
  }
  depends_on = [
    module.atlantis_cluster, aws_lb_target_group.atlantis_target
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = module.atlantis_cluster.asg_name
  lb_target_group_arn   = aws_lb_target_group.atlantis_target.arn
  depends_on = [
    module.atlantis_cluster, aws_lb_target_group.atlantis_target,
    aws_lb.load_balancer
  ]
}