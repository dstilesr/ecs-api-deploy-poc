data "aws_vpc" "deploy_vpc" {
  id = var.vpc_id
}


#################################################
# Load Balancer Group
#################################################
resource "aws_security_group" "load_balancer" {
  name   = "LoadBalancerSG"
  vpc_id = data.aws_vpc.deploy_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "lb_ingress" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "lb_egress" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = data.aws_vpc.deploy_vpc.cidr_block
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}


#################################################
# Service Group
#################################################
resource "aws_security_group" "service" {
  name   = "ServiceSG"
  vpc_id = data.aws_vpc.deploy_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "srv_ingress" {
  security_group_id = aws_security_group.service.id

  cidr_ipv4   = data.aws_vpc.deploy_vpc.cidr_block
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "srv_egress" {
  security_group_id = aws_security_group.service.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
