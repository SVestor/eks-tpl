resource "grafana_contact_point" "contact_point_954743bb3daccafe" {
  name = "email receiver"

  email {
    addresses = ["<example@email.com>"]
  }
}
resource "grafana_contact_point" "contact_point_cc16e20de8b0f5f9" {
  name = "slack-message"

  slack {
    url       = "https://hooks.slack.com/services/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"
    recipient = "#alerts-prod"
  }
}
resource "grafana_contact_point" "contact_point_48e8cc8eb0c20371" {
  name = "system-operations-team"

  email {
    addresses    = ["cloud@svestor.link"]
    single_email = false
  }
}
