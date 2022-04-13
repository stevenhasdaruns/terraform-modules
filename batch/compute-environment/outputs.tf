output "arn" {
  description = "ARN of the compute environment."
  value       = "${aws_batch_compute_environment.env.arn}"
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster for the compute environment."
  value       = "${aws_batch_compute_environment.env.ecs_cluster_arn}"
}
