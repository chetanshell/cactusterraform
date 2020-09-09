resource "aws_autoscaling_group" "cactus-asg" {
    name                        = "cactus-asg"
    max_size                    = "${var.max_instance_size}"
    min_size                    = "${var.min_instance_size}"
    desired_capacity            = "${var.desired_capacity}"
    vpc_zone_identifier         = ["${aws_subnet.public_subnet_01.id}", "${aws_subnet.public_subnet_02.id}"]
    launch_configuration        = "${aws_launch_configuration.cactus-launch-config.name}"
    health_check_type           = "ELB"
  }

  resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = "${aws_autoscaling_group.cactus-asg.id}"
  alb_target_group_arn = "${aws_alb_target_group.cactus-tg.arn}"
}
