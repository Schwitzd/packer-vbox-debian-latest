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
}