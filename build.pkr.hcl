packer {
    required_plugins {
      virtualbox = {
        version = ">= 1.0.5"
        source  = "github.com/hashicorp/virtualbox"
      }
    }
}

build {
  sources = ["source.virtualbox-iso.debian-latest"]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /boot/efi/EFI/boot",
      "sudo cp /boot/efi/EFI/debian/grubx64.efi /boot/efi/EFI/boot/bootx64.efi"
    ]
  }
}