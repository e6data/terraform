resource "aws_autoscaling_group_tag" "mytag" {

  autoscaling_group_name = var.autoscaling_group_name
  
  tag {
    key                 = var.tag_key
    value               = var.tag_value
    propagate_at_launch = true
  }

}