# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT CONTROLS WHAT TRAFFIC CAN GO IN AND OUT OF THE ELB
# ------------------------------------------------------------------------------

resource "aws_security_group" "elb" {
  name          = "sg_${var.environment}_${var.region}_${var.function}-elb_${var.sequence}"
  description = "Security group for ${var.service} ELB"
  vpc_id      = var.vpc_id

  #tags = var.security_group_tags
  tags = {
    Name        = "sg_${var.environment}_${var.region}_${var.function}-elb_${var.sequence}"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
    Service     = var.service
  }
  depends_on = [module.vault_cluster, module.consul_cluster]
}

resource "aws_security_group_rule" "allow_inbound_api" {
  type        = "ingress"
  from_port   = var.lb_port_443
  to_port     = var.lb_port_443
  protocol    = "tcp"
  cidr_blocks = var.allowed_inbound_cidr_blocks

  security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "allow_inbound_vault" {
  type        = "ingress"
  from_port   = var.lb_port_8200
  to_port     = var.lb_port_8200
  protocol    = "tcp"
  cidr_blocks = var.allowed_inbound_cidr_blocks

  security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.allowed_outbound_cidr_blocks

  security_group_id = aws_security_group.elb.id
}


# ------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER
# ------------------------------------------------------------------------------

resource "aws_lb" "load_balancer" {
  name               = "elb-${var.environment}-${var.region}-${var.function}-${var.sequence}" # Cannot be longer than 32 characters
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.elb.id]
  subnets            = [
    data.aws_subnet.eu-central-1-1a.id,
    data.aws_subnet.eu-central-1-1b.id,
    data.aws_subnet.eu-central-1-1c.id,
  ]

  enable_deletion_protection = false

  tags       = {
    Name        = "elb-${var.environment}-${var.region}-${var.function}-${var.sequence}"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
    Service     = var.service
  }
  depends_on = [module.vault_cluster]
}

resource "aws_lb_target_group" "target" {
  name        = "tg-${var.environment}-${var.region}-${var.function}-${var.sequence}"
  port        = var.target-port
  protocol    = var.listener-protocol
  target_type = var.target-type
  vpc_id      = var.vpc_id

  depends_on = [module.vault_cluster]
}

resource "aws_lb_listener" "front_end_8200" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.target-port
  protocol          = "HTTP"
  certificate_arn   = var.acm_cert_arn
  default_action {
    type             = var.listener-default-action-type
    target_group_arn = aws_lb_target_group.target.arn
  }
  depends_on        = [
    aws_lb_target_group.target
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = module.vault_cluster.asg_name
  lb_target_group_arn    = aws_lb_target_group.target.arn
  depends_on             = [
    aws_lb_target_group.target, aws_lb.load_balancer
  ]
}