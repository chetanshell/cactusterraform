# Creating ECS cluster
resource "aws_ecs_cluster" "cactus-ecs-cluster" {
    name = "${var.ecs_cluster}"
}

resource "aws_ecs_capacity_provider" "cactus" {
  name = "capacity-provider-cactus"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = "${aws_autoscaling_group.cactus-asg.arn}"
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

# Task definition
resource "aws_ecs_task_definition" "task-definition-cactus" {
  family                = "web-family"
  container_definitions = file("container-definitions/cont-def.json")
  network_mode          = "bridge"
  tags = {
    "project"       = "cactus"
  }
}

# Service
resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = "${aws_ecs_cluster.cactus-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task-definition-cactus.arn}"
  desired_count   = 5
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_alb_target_group.cactus-tg.arn}"
    container_name   = "pythonapp"
    container_port   = 80
  }
  
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_alb_listener.cactus-listener]
}

# Cloudwatch LogGroup
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "project"       = "cactus"
  }
}