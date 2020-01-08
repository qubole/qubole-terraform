/*
Reference in Terraform: https://github.com/terraform-providers/terraform-provider-google/issues/2902

NOT SUPPORTED BY CLOUD DM AS SERVICE NETWORKING IS NOT A SUPPORTED GCP TYPE. SEE https://cloud.google.com/deployment-manager/docs/configuration/supported-gcp-types
*/

resource "google_service_networking_connection" "cloud_sql_proxy_svc_networking_connection" {
  network = google_compute_network.cloud_sql_proxy_vpc.self_link
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.cloudsql_int_address_range.name]
}

