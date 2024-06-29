source "virtualbox-iso" "debian-latest" {
  vm_name            = var.vm_name
  iso_url            = var.iso_url
  iso_checksum       = var.iso_checksum
  output_directory   = "output-debian-latest"
  guest_os_type      = "Debian_64"
  headless           = false
  http_directory     = "http"
  http_port_min      = 8081
  http_port_max      = 8081
  boot_wait          = "5s"
  boot_command       =  [
        "c",
        "linux /install.amd/vmlinuz ",
        "ipv6.disable=1 auto=true priority=critical ",
        "preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg ",
        "vga=788 --- quiet<enter><wait>",
        "initrd /install.amd/initrd.gz<enter><wait>",
        "boot<enter>"
  ]
  firmware                = "efi"
  cpus                    = var.vm_cpus
  memory                  = var.vm_ram
  nic_type                = "82545EM"
  hard_drive_interface    = "pcie"
  disk_size               = var.vm_disk_size
  hard_drive_discard      = true
  ssh_wait_timeout        = "20m"
  ssh_username            = var.vm_user
  ssh_private_key_file    = var.ssh_private_key
  ssh_port                = 22
  guest_additions_mode    = "upload"
  shutdown_command        = "echo 'vagrant' | sudo -S shutdown -P now"
  post_shutdown_delay     = "30s"
  virtualbox_version_file = ".vbox_version"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--vram", "33"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--tpm-type", "2.0"],
    ["modifyvm", "{{.Name}}", "--clipboard-mode", "bidirectional"],
    ["modifyvm", "{{.Name}}", "--paravirtprovider", "none"],
    [ "modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--vrde", "on"],
    ["modifyvm", "{{.Name}}", "--boot1", "dvd"],
    ["modifyvm", "{{.Name}}", "--boot2", "disk"],
    ["modifyvm", "{{.Name}}", "--boot3", "none"],
    ["modifyvm", "{{.Name}}", "--boot4", "none"]
  ]
}