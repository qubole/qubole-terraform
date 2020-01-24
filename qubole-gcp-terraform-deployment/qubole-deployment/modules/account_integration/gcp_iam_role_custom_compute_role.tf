/*
Creates a Custom Role to work with Compute Engine to
 1. Handle Compute resources like VMs, Disks, Addresses etc
 2. Handle Network resources like firewalls and list VPCs

 This is for the following reason:
 1. Qubole uses the custom Compute Role to list networks, create vms, create addresses, tag instances and pass IAM service accounts to other instances

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/


resource "google_project_iam_custom_role" "qubole_custom_compute_role" {
  project = var.data_lake_project
  role_id = "${var.qubole_custom_compute_role_id}_${var.deployment_suffix}"
  title = "${var.qubole_custom_compute_role_title}_${var.deployment_suffix}"
  description = "Custom compute role for Qubole to orchestrate VMs"
  permissions = [
    "compute.addresses.use",
    "compute.disks.create",
    "compute.disks.delete",
    "compute.disks.get",
    "compute.disks.list",
    "compute.disks.setLabels",
    "compute.disks.use",
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.firewalls.get",
    "compute.firewalls.list",
    "compute.firewalls.update",
    "compute.instances.attachDisk",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.detachDisk",
    "compute.instances.get",
    "compute.instances.list",
    "compute.instances.reset",
    "compute.instances.resume",
    "compute.instances.setLabels",
    "compute.instances.setMetadata",
    "compute.instances.setServiceAccount",
    "compute.instances.setTags",
    "compute.instances.start",
    "compute.instances.stop",
    "compute.instances.suspend",
    "compute.instances.use",
    "compute.networks.updatePolicy",
    "compute.networks.use",
    "compute.networks.useExternalIp",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp",
    "compute.regions.get",
    "compute.networks.list",
    "compute.subnetworks.list",
    "compute.diskTypes.list"]
}