resource "aws_iam_role" "ecs-task-defination-role" {
  name = var.ecs-task-defination-role 

}

resource "aws_iam_role_policy_attachment" "ecs_task_defination_attachment1" {
  role = aws_iam_role.test_role.ecs-task-defination-role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs-task-defination-role
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonMSKFullAccess" {
  role = aws_iam_role.test_role.ecs-task-defination-role
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
}
