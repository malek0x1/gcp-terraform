// Get project details
data "google_project" "project" {
  project_id = var.project_id
}

// Deploy a dummy Cloud Run service to trigger robot account creation
resource "null_resource" "trigger_robot_account" {

  provisioner "local-exec" {
    command = <<EOT
      # Deploy a dummy Cloud Run service
      gcloud run deploy dummy-service \
        --image=gcr.io/cloudrun/hello \
        --region=${var.region} \
        --allow-unauthenticated \
        --project=${var.project_id}

      # Cleanup: Delete the dummy Cloud Run service
      gcloud run services delete dummy-service \
        --region=${var.region} \
        --project=${var.project_id} --quiet
    EOT
  }
}

// Grant the robot service account artifact registry reader role
resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.main_project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
}
