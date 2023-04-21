variable "team_to_notify" {
  type        = string
  description = "Teams/People to notify. Recipient shall start with @ for example @example@email.com and multiple recipients shall be separated with space."
  default     = ""
}

variable "default_notify_message" {
  type        = string
  description = "Default message to send in case alert is triggered"
  default     = ""
}

variable "monitors" {
  type        = any
  description = "Map of Datadog synthetic configurations."
}
