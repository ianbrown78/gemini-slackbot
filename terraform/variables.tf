variable "region" {
  type    = string
  default = "australia-southeast1"
}

variable "project_id" {
  type    = string
  default = ""
}

variable "api_list" {
  type = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "generativelanguage.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}