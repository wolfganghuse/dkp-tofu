output "nodes" {
  description = "Control plane endpoints"

  value = {
    control_plane = {
      private_address      = yamlencode(nutanix_virtual_machine.control_plane.*.nic_list.0.ip_endpoint_list.0.ip)
    }
    worker = {
      private_address      = yamlencode(nutanix_virtual_machine.worker.*.nic_list.0.ip_endpoint_list.0.ip)
    }
  }
}
