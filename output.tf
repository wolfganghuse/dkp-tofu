output "controlplane" {
  description = "Control plane endpoints"

  value = {
    control_plane = {
      cluster_name         = var.cluster_name
      private_address      = nutanix_virtual_machine.control_plane.*.nic_list.0.ip_endpoint_list.0.ip
      ssh_port             = var.ssh_port
      ssh_private_key_file = var.ssh_private_key_file
      ssh_user             = var.ssh_username
    }
  }
}

output "workers" {
  value = {
    control_plane = {
      cluster_name         = var.cluster_name
      private_address      = nutanix_virtual_machine.control_plane.*.nic_list.0.ip_endpoint_list.0.ip
      ssh_port             = var.ssh_port
      ssh_private_key_file = var.ssh_private_key_file
      ssh_user             = var.ssh_username
    }
  }
}