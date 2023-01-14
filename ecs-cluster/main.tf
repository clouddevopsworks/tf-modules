resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.application}-${var.tags["environment"]}"
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

