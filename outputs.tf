output "synthetic_http_monitor_names" {
  value       = values(datadog_synthetics_test.synthetic_http_monitor)[*].name
  description = "Names of the created Datadog monitors"
}

output "synthetic_http_monitor_ids" {
  value       = values(datadog_synthetics_test.synthetic_http_monitor)[*].id
  description = "IDs of the created Datadog monitors"
}

output "synthetic_http_monitors" {
  value       = datadog_synthetics_test.synthetic_http_monitor[*]
  description = "Datadog monitor outputs"
}
