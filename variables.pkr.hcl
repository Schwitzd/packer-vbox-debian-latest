variable "vm_name" {
  type    = string
}

variable "vm_cpus" {
  type    = number
}

variable "vm_ram" {
  type    = number
}

variable "vm_disk_size" {
  type    = number
}

variable "vm_user" {
  type    = string
}

variable "iso_url" {
  type    = string
}

variable "iso_checksum" {
  type    = string
}

variable "ssh_private_key" {
  type    = string
}
