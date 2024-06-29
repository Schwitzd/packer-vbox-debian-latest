# Packer Debian Latest Provisioning

This project automates the provisioning of a Virtual Machine (VM) on VirtualBox using Packer and Debian. It collects user inputs for VM configuration, generates SSH keys, creates a preseed file and writes the necessary configuration files before triggering Packer to build the VM.

## Prerequisites

Before running the script, ensure you have the following software installed:

- [Packer](https://www.packer.io/)
- [VirtualBox](https://www.virtualbox.org/)

## Usage

1. Clone this repository:

    ```sh
    git clone https://github.com/Schwitzd/packer-vbox-debian-latest.git
    ```

1. Execute the provisioning sript:

    ```sh
    cd packer-vbox-debian-latest
    chmod +x provisioning.sh
    sh provisioning.sh
    ```
