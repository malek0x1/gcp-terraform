variable "project_id" {
  description = "The GCP project ID"
  type        = string
}
variable "secrets" {
  description = "Map of secrets to manage"
  type = map(object({
    secret_data = string
  }))

}
variable "region" {
  type = string

}
