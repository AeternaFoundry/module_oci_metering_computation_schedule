resource "oci_metering_computation_schedule" "metering_computation_schedules" {
  for_each = var.metering_computation_schedules

  compartment_id       = each.value.compartment_id
  name                 = each.value.name
  schedule_recurrences = each.value.schedule_recurrences
  time_scheduled       = each.value.time_scheduled
  defined_tags         = each.value.defined_tags
  description          = each.value.description
  freeform_tags        = each.value.freeform_tags
  output_file_format   = each.value.output_file_format
  saved_report_id      = each.value.saved_report_id

  result_location {
    bucket        = each.value.result_location.bucket
    location_type = each.value.result_location.location_type
    namespace     = each.value.result_location.namespace
    region        = each.value.result_location.region
  }

  dynamic "query_properties" {
    for_each = each.value.query_properties != null ? [each.value.query_properties] : []
    content {
      compartment_depth = query_properties.value.compartment_depth
      date_range {
        date_range_type         = query_properties.value.date_range.date_range_type
        dynamic_date_range_type = query_properties.value.date_range.dynamic_date_range_type
        time_usage_ended        = query_properties.value.date_range.time_usage_ended
        time_usage_started      = query_properties.value.date_range.time_usage_started
      }
      filter      = query_properties.value.filter
      granularity = query_properties.value.granularity
      group_by    = query_properties.value.group_by
      dynamic "group_by_tag" {
        for_each = query_properties.value.group_by_tag != null ? query_properties.value.group_by_tag : []
        content {
          key       = group_by_tag.value.key
          namespace = group_by_tag.value.namespace
          value     = group_by_tag.value.value
        }
      }
      is_aggregate_by_time = query_properties.value.is_aggregate_by_time
      query_type           = query_properties.value.query_type
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

