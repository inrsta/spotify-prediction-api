# Make sure to create state bucket beforehand
terraform {
  required_version = ">= 1.0"
  backend "gcs" {
    bucket = "tfstate-mlflow-server-inri"
  }
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project

}

# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "mlflow-server-test" {
  boot_disk {
    auto_delete = true
    device_name = "mlflow-server-test"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230711"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  name         = "mlflow-server-test"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = "projects/${var.gcp_project}/regions/${var.gcp_region}/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "europe-west1-b"
  metadata = {
    startup-script = file("${path.module}/startup.sh")
    ARTIFACT_ROOT  = var.artifact_root_gcs_location
  }
}
