data "template_file" "template" {
  template = file("${path.module}/${var.application}/appspec.tpl")
  vars = {
    taskdefinition_arn = var.taskdefinition_arn
    containername      = var.containername
    containerport      = var.containerport
  }
}

resource "local_file" "appspec" {
  content  = data.template_file.template.rendered
  filename = var.filename
}
