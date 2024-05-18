data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster_name
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

data "nutanix_image" "image" {
  image_name = var.image_name
}


resource "nutanix_virtual_machine" "control_plane" {
  count        = var.control_plane_vm_count
  name         = "${var.cluster_name}-cp-${count.index}"
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.control_plane_vcpus
  num_sockets          = var.control_plane_sockets
  memory_size_mib      = var.control_plane_memory_size

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.metadata.uuid
  }

  disk_list {
    disk_size_mib = var.control_plane_disk_size

    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.metadata.uuid
    }
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("./cloud-config.tftpl", {
    machine_name = "${var.cluster_name}-cp-${count.index}"
    ssh_key      = file(var.ssh_public_key_file)
  }))

}

resource "nutanix_virtual_machine" "worker" {
  count        = var.worker_vm_count
  name         = "${var.cluster_name}-worker-${count.index}"
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.worker_vcpus
  num_sockets          = var.worker_sockets
  memory_size_mib      = var.worker_memory_size

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.metadata.uuid
  }

  gpu_list {
    #device_id = 1150
    #device_id = 9913
    mode = "VIRTUAL"
    name = "NVIDIA_L40S-16C"
    #mode = "PASSTHROUGH_COMPUTE"
    vendor = "NVIDIA"
  }

  disk_list {
    disk_size_mib = var.worker_disk_size

    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.metadata.uuid
    }
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("./cloud-config.tftpl", {
    machine_name = "${var.cluster_name}-worker-${count.index}"
    ssh_key      = file(var.ssh_public_key_file)
  }))

}

resource "local_file" "preprovisoned_inventory" {
  content      = templatefile("preprovisoned_inventory.yaml.tftpl", {
    CLUSTER_NAME = var.cluster_name
    SSH_USER = var.ssh_username
    WORKER_NODES = [for vm in nutanix_virtual_machine.worker : vm.nic_list[0].ip_endpoint_list[0].ip]
    CP_NODES = [for vm in nutanix_virtual_machine.control_plane : vm.nic_list[0].ip_endpoint_list[0].ip]
  })
  filename = "preprovisioned_inventory.yaml"
}
