resource "datadog_synthetics_test" "synthetic_http_monitor" {
  for_each  = { for monitor in var.monitors : monitor.name => monitor }
  type      = "api"
  subtype   = "http"
  name      = try(each.value.name, null)
  status    = try(each.value.status, "paused")
  tags      = try(each.value.tags, [])
  locations = try(each.value.locations, [])
  message   = try(join("", [each.value.message, "\n", var.default_notify_message, " ", var.team_to_notify]), null) #message will append the configured team to notify and default message to the message configured in the .yml files

  request_headers = {
    Content-Type   = try(each.value.request_headers.Content-Type, null)
    Authentication = try(each.value.request_headers.Authentication, null)
  }

  #Multiple assertion can be added dynamically
  dynamic "assertion" {
    for_each = each.value.assertions
    content {
      type     = try(assertion.value.type, null)
      operator = try(assertion.value.operator, null)
      target   = try(assertion.value.target, null)
    }
  }

  options_list {
    tick_every                      = try(each.value.options_list.tick_every, 60)            #default check interval to be 60s
    monitor_priority                = try(each.value.options_list.monitor_priority, 1)       #Priority is default 1
    min_failure_duration            = try(each.value.options_list.min_failure_duration, 360) #default failure duration to be 5 mins
    min_location_failed             = try(each.value.options_list.min_location_failed, 2)    #default min failing locations to be 2
    follow_redirects                = try(each.value.options_list.follow_redirects, null)    #default is false
    monitor_name                    = try(each.value.options_list.monitor_name, null)        #name of the monitor to display on Datadog
    ignore_server_certificate_error = try(each.value.options_list.ignore_server_certificate_error, null)
    allow_insecure                  = try(each.value.options_list.allow_insecure, null)
    retry {
      count    = try(each.value.options_list.retry.count, null)
      interval = try(each.value.options_list.retry.interval, null)
    }
    monitor_options {
      renotify_interval = try(each.value.options_list.monitor_options.renotify_interval, null) #renotify in minutes unit
    }
  }

  request_definition {
    method  = try(each.value.request_definition.method, "GET") #default method set to GET
    url     = try(each.value.request_definition.url, null)
    port    = try(each.value.request_definition.port, null) #port should be set in case port is not 0
    timeout = try(each.value.request_definition.timeout, null)
  }

  #this basic authentication might not be needed for many of the check but its an option to add
  #basically, the default (null) shall be replaced in case we have setting, otherwise, if all is set to "null" then we don overide the default
  request_basicauth {
    password = try(each.value.request_basicauth.password, null)
    type     = try(each.value.request_basicauth.type, null)
    username = try(each.value.request_basicauth.username, null)
  }
}
