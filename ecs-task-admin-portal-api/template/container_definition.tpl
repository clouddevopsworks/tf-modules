[{
  "name": "container-admin-portal-api-nginx-${environment}",
  "image": "${registry}/ecr-admin-portal-api-nginx-${environment}:latest",
  "portMappings": [{
    "containerPort": 80,
    "hostPort": 80,
    "protocol": "tcp"
  }],
  "cpu": ${cpu_nginx},
  "memory": ${memory_nginx},
  "essential": true,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/ecs/container-admin-portal-api-nginx-${environment}",
      "awslogs-region": "${region}",
      "awslogs-stream-prefix": "ecs"
    }
  }
},
{
  "name": "container-admin-portal-api-app-${environment}",
  "image": "${registry}/ecr-admin-portal-api-app-${environment}:latest",
  "essential": true,
  "cpu": ${cpu_app},
  "memory": ${memory_app},
  "environment": [{
      "name": "DB_PASSWORD",
      "value": "${db_password}"
    },
    {
      "name": "MAIL_PASSWORD",
      "value": "${mail_password}"
    },
    {
      "name": "AWS_SECRET_ACCESS_KEY",
      "value": "${aws_secret_access_key}"
    },
    {
      "name": "ROLLBAR_ACCESS_TOKEN",
      "value": "${rollbar_access_token}"
    }
  ],
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/ecs/container-admin-portal-api-app-${environment}",
      "awslogs-region": "${region}",
      "awslogs-stream-prefix": "ecs"
    }
  }
}
]