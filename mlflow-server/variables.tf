variable "tfstate_mlflow_server" {
    description = "GCS bucket where the tfstate will be stored"
}

variable "gcp_region" {
    description = "GCP region to create resources"
    default = "europe-west1"
}

variable "gcp_project" {
    description = "Project ID"

}

variable "service_account_email" {
  description = "The email for the service account"
  type        = string
}

variable "artifact_root_gcs_location" {
  description = "The bucket where to store the artifacts"
  type        = string
}
