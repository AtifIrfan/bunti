resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
  project = "seismic-kingdom-446107-g9"
}

resource "google_compute_instance" "confidential_instance" {
  name             = "my-confidential-instance"
  project = "seismic-kingdom-446107-g9"
  zone             = "us-central1-a"
  machine_type     = "n2d-standard-2"
  min_cpu_platform = "AMD Milan"
  can_ip_forward = true

  confidential_instance_config {
    enable_confidential_compute = true
    confidential_instance_type  = "SEV"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"
    

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
