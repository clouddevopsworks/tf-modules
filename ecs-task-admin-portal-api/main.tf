data "template_file" "container_definition" {
  template = file("${path.module}/template/container_definition.tpl")
  vars = {
    registry              = var.registry
    environment           = "${var.tags["environment"]}"
    db_host               = var.db_host
    db_database           = var.db_database
    db_username           = var.db_username
    db_password           = var.db_password
    mail_username         = var.mail_username
    mail_password         = var.mail_password
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
    aws_bucket            = var.aws_bucket
    aws_url               = var.aws_url
    aws_s3_url            = var.aws_s3_url
    rollbar_access_token  = var.rollbar_access_token
    cpu_app               = var.cpu_app
    memory_app            = var.memory_app
    cpu_nginx             = var.cpu_nginx
    memory_nginx          = var.memory_nginx
    region                = var.region
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "ecs-task-${var.application}-${var.tags["environment"]}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.container_definition.rendered
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(tomap({
    Name = "ecs-task-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

}

