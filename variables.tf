################# Start here to Add your variables #######################
##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our

variable "prefix" {
  description = "TerraformManaged"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "uk-south"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A0"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "20.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name for linux and mysql"
  default     = "terraforAdmin"
}

variable "admin_password" {
  description = "Administrator pw for linux and mysql"
  default     = "StrongPassword123!"
}

variable "height" {
  default     = "400"
  description = "Image height in pixels."
}

variable "width" {
  default     = "600"
  description = "Image width in pixels."
}

variable "placeholder" {
  default     = "Terraform_Created_Asset"
  description = "This resource was created with Terraform"
}
