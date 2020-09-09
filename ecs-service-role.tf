resource "aws_iam_role" "cactus-ecs-service-role" {
    name                = "cactus-ecs-service-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.cactus-ecs-service-policy.json}"
}

resource "aws_iam_role_policy_attachment" "cactus-ecs-service-role-attachment" {
    role       = "${aws_iam_role.cactus-ecs-service-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "cactus-ecs-service-policy" {
    statement {
        actions = ["sts:AssumeRole"] 

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}