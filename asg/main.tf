resource "aws_autoscaling_group" "autoscaling_group" {
  name                = "asg-${var.application}-${var.tags["environment"]}"
  vpc_zone_identifier = var.subnet_id
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  health_check_type   = var.health_check_type

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "environment"
    value               = var.tags["environment"]
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

resource "aws_launch_template" "launch_template" {
  name = "lt-${var.application}-${var.tags["environment"]}"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.root_vol_size
      volume_type           = "gp2"
      delete_on_termination = false
    }
  }
  disable_api_stop        = true
  disable_api_termination = true
  iam_instance_profile {
    name = var.instance_profile
  }
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  monitoring {
    enabled = var.detailed_monitoring
  }
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.sg_id
  }
  /* vpc_security_group_ids = var.sg_id */
  tag_specifications {
    resource_type = "instance"
    tags = merge(tomap({
      Name = "ec2-${var.application}-${var.tags["environment"]}",
      "environment" = "${var.tags["environment"]}" }),
      var.default_tags,
      var.tags
    )
  }
  user_data = filebase64("${path.module}/user-data/${var.tags["environment"]}/${var.application}/user-data.sh")
}
