variable "cluster_name" {
  description = "Name of the cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.cluster_name))
    error_message = "Value of cluster_name should be lowercase and can only contain alphanumeric characters and hyphens(-)."
  }
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
  type        = string
}

variable "ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
  type        = number
}

variable "ssh_username" {
  description = "SSH user, used only in output"
  default     = "ubuntu"
  type        = string
}

variable "ssh_private_key_file" {
  description = "SSH private key file used to access instances"
  default     = ""
  type        = string
}

variable "control_plane_vm_count" {
  description = "number of control plane instances"
  default     = 3
  type        = number
}

variable "worker_vm_count" {
  description = "number of control plane instances"
  default     = 3
  type        = number
}
# Nutanix specific settings

variable "nutanix_cluster_name" {
  description = "Name of the Nutanix Cluster which will be used for this Kubernetes cluster"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "image_name" {
  description = "Image to be used for instances"
  type        = string
}

variable "control_plane_vcpus" {
  default     = 1
  description = "Number of vCPUs per socket for control plane nodes"
  type        = number
}

variable "control_plane_sockets" {
  default     = 1
  description = "Number of sockets for control plane nodes"
  type        = number
}

variable "control_plane_memory_size" {
  default     = 4096
  description = "Memory size, in Mib, for control plane nodes"
  type        = number
}

variable "control_plane_disk_size" {
  default     = 102400
  description = "Disk size size, in Mib, for control plane nodes"
  type        = number
}

variable "worker_vcpus" {
  default     = 1
  description = "Number of vCPUs per socket for worker nodes"
  type        = number
}

variable "worker_sockets" {
  default     = 1
  description = "Number of sockets for worker nodes"
  type        = number
}

variable "worker_memory_size" {
  default     = 4096
  description = "Memory size, in Mib, for worker nodes"
  type        = number
}

variable "worker_disk_size" {
  default     = 50
  description = "Disk size size, in Gb, for worker nodes"
  type        = number
}


variable "nutanix_user" {
  default     = "admin"
  description = "Prism Central account"
  type        = string
}


variable "nutanix_password" {
  description = "Prism Central password"
  type        = string
}


variable "nutanix_endpoint" {
  description = "Prism Central endpoing"
  type        = string
}


variable "gpu_worker_vm_count" {
  description = "Number of GPU worker VMs to create. Set to 0 to disable."
  default     = 0
}

variable "gpu_worker_sockets" {
  default     = 8
  description = "Number of sockets for worker nodes"
  type        = number
}

variable "gpu_worker_memory_size" {
  default     = 65536
  description = "Memory size, in Mib, for worker nodes"
  type        = number
}

variable "gpu_worker_disk_size" {
  default     = 307200
  description = "Disk size size, in Gb, for worker nodes"
  type        = number
}

variable "gpu_worker_vcpus" {
  default     = 1
  description = "Number of vCPUs per socket for gpu nodes"
  type        = number
}

variable "gpu_vendor" {
  default     = "NVIDIA"
  description = "Type of GPU to attach to the VM."
}
variable "gpu_count" {
  description = "Number of GPUs to attach to each VM."
  default     = 1
}
variable "gpu_device" {
  default     = "9913"
  description = "1183 NVIDIA_L40S-16C or 9913 L40S"
}

variable "gpu_mode" {
  default     = "PASSTHROUGH_COMPUTE"
  description = "PASSTHROUGH_COMPUTE or VIRTUAL"
}

variable "project" {
  type = string
}