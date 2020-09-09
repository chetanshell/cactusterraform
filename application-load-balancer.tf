resource "aws_alb" "cactus-lb" {
    name                = "cactus-lb"
    security_groups     = ["${aws_security_group.cactus_public_sg.id}"]
    subnets             = ["${aws_subnet.public_subnet_01.id}", "${aws_subnet.public_subnet_02.id}"]

    tags = {
      Name = "cactus-lb"
    }
}

resource "aws_alb_target_group" "cactus-tg" {
    name                = "cactus-tg"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.cactus_vpc.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
      Name = "cactus-tg"
    }
}

resource "aws_alb_listener" "cactus-listener" {
    load_balancer_arn = "${aws_alb.cactus-lb.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.cactus-tg.arn}"
        type             = "forward"
    }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "${var.ecs_key_pair_name}" 
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_launch_configuration" "cactus-launch-config" {
    name                          = "cactus-launch-config"
    image_id                      = "ami-0a54aef4ef3b5f881"
    instance_type                 = "t2.xlarge"
    # image_id                      = "${var.ami_id}"
    # instance_type                 = "${var.instance_type}"
    iam_instance_profile          = "${aws_iam_instance_profile.cactus-inst-profile.id}"

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = ["${aws_security_group.cactus_public_sg.id}"]
    associate_public_ip_address = "true"
    key_name                    = "${var.ecs_key_pair_name}"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF
}