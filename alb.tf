module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  version                    = "10.5.0"
  name                       = "my-alb"
  vpc_id                     = module.myvpc.vpc_id
  subnets                    = module.myvpc.public_subnets
  enable_deletion_protection = false
  create_security_group = false

  # Security Group
  security_groups = [module.SG.SG_allow_http_to_ALB_id]

  listeners = {

    fixed-response = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Welcome to my project"
        status_code  = "200"
      }
      rules = {
        my-app1-rules = {
          priority = 10
          actions = [{
            forward = {
              target_group_key = "tg-app1"
            }
          }]
        
          conditions = [{
            path_pattern = {
              values = ["/app1*"]
          }
        }]
      }
        my-app2-rules = {
          priority = 20
          actions = [{
            forward = {
              target_group_key = "tg-app2"
            }
          }]
        
          conditions = [{
            path_pattern = {
              values = ["/app2*"]
          }
        }]
      }
      }

    }
  }

  target_groups = {
    tg-app1 = {
      name_prefix = "app1-"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      #target_id   = module.ec2_app1.id
      load_balancing_cross_zone_enabled = true
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
    tg-app2 = {
      name_prefix = "app2-"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      #target_id   = module.ec2_app1.id
      load_balancing_cross_zone_enabled = true
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}

resource "aws_lb_target_group_attachment" "tg-app1" {
  target_group_arn = module.alb.target_groups["tg-app1"].arn
  target_id        = module.ec2_app1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-app2" {
  target_group_arn = module.alb.target_groups["tg-app2"].arn
  target_id        = module.ec2_app2.id
  port             = 80
}



