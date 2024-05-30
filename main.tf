# Data Sources
data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster_name
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

data "nutanix_image" "image" {
  image_name = var.image_name
}

# Control Plane VM Resource
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

# Worker VM Resource
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

# GPU Worker VM Resource (conditional)
resource "nutanix_virtual_machine" "gpu_worker" {
  count        = var.gpu_worker_vm_count
  name         = "${var.cluster_name}-gpu-worker-${count.index}"
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.gpu_worker_vcpus
  num_sockets          = var.gpu_worker_sockets
  memory_size_mib      = var.gpu_worker_memory_size

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.metadata.uuid
  }

  disk_list {
    disk_size_mib = var.gpu_worker_disk_size

    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.metadata.uuid
    }
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("./cloud-config.tftpl", {
    machine_name = "${var.cluster_name}-gpu-worker-${count.index}"
    ssh_key      = file(var.ssh_public_key_file)
  }))

  lifecycle {
    create_before_destroy = true
  }
  
  dynamic "gpu_list" {
    for_each = var.gpu_count > 0 ? [1] : []
    content {
      mode     = var.gpu_mode
      vendor    = var.gpu_vendor
      device_id = var.gpu_device
    }
  }
}

# Local File Resource
resource "local_file" "preprovisoned_inventory" {
  content      = templatefile("preprovisoned_inventory.yaml.tftpl", {
    CLUSTER_NAME = var.cluster_name
    SSH_USER = var.ssh_username
    WORKER_NODES = [for vm in nutanix_virtual_machine.worker : vm.nic_list[0].ip_endpoint_list[0].ip]
    CP_NODES = [for vm in nutanix_virtual_machine.control_plane : vm.nic_list[0].ip_endpoint_list[0].ip]
    GPU_WORKER_NODES = [for vm in nutanix_virtual_machine.gpu_worker : vm.nic_list[0].ip_endpoint_list[0].ip]
  })
  filename = "preprovisioned_inventory.yaml"
}


