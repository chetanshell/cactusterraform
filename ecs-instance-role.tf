resource "aws_iam_role" "cactus-ecs-inst-role" {
    name                = "cactus-ecs-inst-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.cactus-ecs-inst-policy.json}"
}

data "aws_iam_policy_document" "cactus-ecs-inst-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "cactus-ecs-inst-role-attachment" {
    role       = "${aws_iam_role.cactus-ecs-inst-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "cactus-inst-profile" {
    name = "cactus-inst-profile"
    path = "/"
    role = "${aws_iam_role.cactus-ecs-inst-role.id}"
    provisioner "local-exec" {
      command = "sleep 10"
    }
}