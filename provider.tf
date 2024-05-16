terraform{
  required_providers{
    nutanix = {
      source = "nutanix/nutanix"
    }
  }
}


provider "nutanix" {
    username  = var.nutanix_user
    password  = var.nutanix_password
    endpoint  = var.nutanix_endpoint
    insecure  = true
    port      = 9440
}