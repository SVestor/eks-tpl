resource "grafana_rule_group" "rule_group_15eca09fbbcd32c6" {
  org_id           = 1
  name             = "volume_evaluation_group"
  folder_uid       = "deoya43vrjz7kc"
  interval_seconds = 60

  rule {
    name      = "Persistent Volume Usage per Namespace (monitoring)"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 1800
        to   = 0
      }

      datasource_uid = "P3CCD15422F6EB158"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"P3CCD15422F6EB158\"},\"editorMode\":\"code\",\"expr\":\"kubelet_volume_stats_used_bytes{namespace=~\\\"monitoring\\\"} / kubelet_volume_stats_capacity_bytes{namespace=~\\\"monitoring\\\"}\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"{{persistentvolumeclaim}}\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.81],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state   = "NoData"
    exec_err_state  = "Error"
    for             = "3m"
    keep_firing_for = "5m"
    annotations = {
      __dashboardUid__ = "28fc27c1-d54b-42c5-be73-39fb141dc25f"
      __panelId__      = "3"
      description      = "The volume capacity evaluation"
      summary          = "The volume capacity is 81% or  higher!"
    }
    labels = {
      namespace = "monitoring"
      pv        = "usage"
      pvc       = "usage"
      volume    = "usage"
    }
    is_paused = false

    notification_settings {
      contact_point   = "slack-message"
      group_by        = null
      group_interval  = "3m"
      repeat_interval = "30m"
      mute_timings    = null
    }
  }
  rule {
    name      = "Persistent Volume Usage per Namespace (grafana)"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 1800
        to   = 0
      }

      datasource_uid = "P3CCD15422F6EB158"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"P3CCD15422F6EB158\"},\"editorMode\":\"code\",\"expr\":\"kubelet_volume_stats_used_bytes{namespace=~\\\"grafana\\\"} / kubelet_volume_stats_capacity_bytes{namespace=~\\\"grafana\\\"}\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"{{persistentvolumeclaim}}\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.81],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state   = "NoData"
    exec_err_state  = "Error"
    for             = "3m"
    keep_firing_for = "5m"
    annotations = {
      __dashboardUid__ = "28fc27c1-d54b-42c5-be73-39fb141dc25f"
      __panelId__      = "3"
      description      = "The volume capacity evaluation"
      summary          = "The volume capacity is 81% or  higher!"
    }
    labels = {
      namespace = "grafana"
      pv        = "usage"
      pvc       = "usage"
      volume    = "usage"
    }
    is_paused = false

    notification_settings {
      contact_point   = "slack-message"
      group_by        = null
      group_interval  = "3m"
      repeat_interval = "30m"
      mute_timings    = null
    }
  }
}
