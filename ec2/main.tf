data "template_file" "bootstrap" {
  template = file("${path.module}/templates/${var.tags["environment"]}/bootstrap.sh.tpl")
}

resource "aws_instance" "ec2_instance" {
  ami       = var.image_id
  subnet_id = var.subnet_id
  key_name  = var.key_name
  # security_groups      = var.security_groups
  vpc_security_group_ids = var.security_groups
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile
  user_data              = data.template_file.bootstrap.rendered
  root_block_device {
    volume_size = 10
  }
  volume_tags = merge(tomap({
    Name = "instance-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

  tags = merge(tomap({
    Name = "instance-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

}


/* resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = var.region
  size              = var.disk_size

} */


/* resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.ec2_instance.id
} */

resource "aws_ebs_volume" "ebs_volume" {
  count             = length(var.disk_size)
  availability_zone = var.availability_zone
  size              = var.disk_size[count.index]
}


resource "random_string" "random" {
  count            = length(var.disk_size)
  length           = 1
  special          = false
  lower            = true
  numeric          = false
  upper            = false
}

resource "aws_volume_attachment" "ebs_att" {
  count       = length(var.disk_size)
  device_name = "/dev/sd${random_string.random.*.result[count.index]}"
  volume_id   = aws_ebs_volume.ebs_volume.*.id[count.index]
  instance_id = aws_instance.ec2_instance.id
}





/* resource "aws_ebs_volume" "ebs_volume" {
  for_each = var.disk_size
      content {
      availability_zone = var.region
      size              = each.value
    }
} */






















/* resource "null_resource" "ssh" {

  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_file_path)
    host        = aws_instance.ec2_instance.public_ip

  }

  provisioner "remote-exec" {
    inline = [
      "sudo growpart /dev/xvda 4",
      "sudo xfs_growfs /dev/xvda4",
    ]
  }
} */