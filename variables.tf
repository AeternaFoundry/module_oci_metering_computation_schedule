variable "metering_computation_schedules" {
  description = <<EOT
Map of metering_computation_schedules, attributes below
Required:
    - compartment_id
    - name
    - schedule_recurrences
    - time_scheduled
    - result_location (block):
        - bucket (required)
        - location_type (required)
        - namespace (required)
        - region (required)
Optional:
    - defined_tags
    - description
    - freeform_tags
    - output_file_format
    - saved_report_id
    - query_properties (block):
        - compartment_depth (optional)
        - date_range (required, block):
            - date_range_type (required)
            - dynamic_date_range_type (optional)
            - time_usage_ended (optional)
            - time_usage_started (optional)
        - filter (optional)
        - granularity (required)
        - group_by (optional)
        - group_by_tag (optional, block):
            - key (optional)
            - namespace (optional)
            - value (optional)
        - is_aggregate_by_time (optional)
        - query_type (optional)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id       = string
    name                 = string
    schedule_recurrences = string
    time_scheduled       = string
    defined_tags         = optional(map(string))
    description          = optional(string)
    freeform_tags        = optional(map(string))
    output_file_format   = optional(string)
    saved_report_id      = optional(string)
    result_location = object({
      bucket        = string
      location_type = string
      namespace     = string
      region        = string
    })
    query_properties = optional(object({
      compartment_depth = optional(number)
      date_range = object({
        date_range_type         = string
        dynamic_date_range_type = optional(string)
        time_usage_ended        = optional(string)
        time_usage_started      = optional(string)
      })
      filter      = optional(string)
      granularity = string
      group_by    = optional(list(string))
      group_by_tag = optional(list(object({
        key       = optional(string)
        namespace = optional(string)
        value     = optional(string)
      })))
      is_aggregate_by_time = optional(bool)
      query_type           = optional(string)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.metering_computation_schedules : (
        contains([for v in ["OBJECT_STORAGE"] : lower(v)], lower(v.result_location.location_type))
      )
    ])
    error_message = "must be one of: \"OBJECT_STORAGE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.metering_computation_schedules : (
        v.query_properties == null || (contains([for v in ["DYNAMIC", "STATIC"] : lower(v)], lower(v.query_properties.date_range.date_range_type)))
      )
    ])
    error_message = "must be one of: \"DYNAMIC\", \"STATIC\""
  }
}

