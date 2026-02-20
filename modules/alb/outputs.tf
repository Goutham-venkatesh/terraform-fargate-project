output "alb" { value = aws_lb.alb.arn }
output "target_group_3000" { value = aws_lb_target_group.tg_3000.arn }
output "target_group_3001" { value = aws_lb_target_group.tg_3001.arn }