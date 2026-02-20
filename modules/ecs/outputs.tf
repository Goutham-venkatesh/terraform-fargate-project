output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "patient_service_name" {
  value = aws_ecs_service.patient_service.name
}

output "appointment_service_name" {
  value = aws_ecs_service.appointment_service.name
}