resource "aws_ecr_repository" "patient_service" {
  name = "${var.environment}-patient-service"
}

resource "aws_ecr_repository" "appointment_service" {
  name = "${var.environment}-appointment-service"
}