#Configure GCP Provider
provider "google" {
  credentials = "${file("CREDENTIALS_FILE.json")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone = "${var.zone}"
}

provider "google-beta" {
  credentials = "${file("CREDENTIALS_FILE.json")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone = "${var.zone}"
  version = "~> 1.19"
}