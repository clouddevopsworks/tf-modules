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
  "environment": [
    {
      "name": "DB_HOST",
      "value": "${db_host}"
    },
    {
      "name": "DB_DATABASE",
      "value": "${db_database}"
    },
    {
      "name": "DB_USERNAME",
      "value": "${db_username}"
    },
    {
      "name": "DB_PASSWORD",
      "value": "${db_password}"
    },
    {
      "name": "MAIL_USERNAME",
      "value": "${mail_username}"
    },
    {
      "name": "MAIL_PASSWORD",
      "value": "${mail_password}"
    },
    {
      "name": "AWS_ACCESS_KEY_ID",
      "value": "${aws_access_key_id}"
    },
    {
      "name": "AWS_SECRET_ACCESS_KEY",
      "value": "${aws_secret_access_key}"
    },
    {
      "name": "AWS_BUCKET",
      "value": "${aws_bucket}"
    }, 
    {
      "name": "AWS_URL",
      "value": "${aws_url}"
    },   
    {
      "name": "AWS_S3_URL",
      "value": "${aws_s3_url}"
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