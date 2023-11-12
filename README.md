# Valetudo Roborock S50 Tailscale Installer

This repository contains a script to install Tailscale, a private wireguard network, on Roborock vacuum robots. It has only been tested on the Roborock S50 vacuum robot. It enables secure and easy access to your Roborock device from anywhere.

## Overview

The script is designed to automatically detect the CPU architecture of the Roborock robot and download the appropriate Tailscale package. It then installs Tailscale and configures it to start on boot, ensuring continuous connectivity.

## Prerequisites

- A Roborock vacuum robot with network connectivity.
- SSH access to the robot.

## Installation

1. Clone this repository or download the script directly to your Roborock robot.
2. Make the script executable: `chmod +x install_tailscale.sh`
3. Run the script: `./install_tailscale.sh`

## Usage

After installation, you can use Tailscale commands to manage your connection. For example:

- To log in: `tailscale up`
- To check the status: `tailscale status`

## Contributions

Contributions are welcome! If you have improvements or bug fixes, please open a pull request.

## License

This script is released under the MIT License.

## Disclaimer

This script is not officially affiliated with Tailscale or Roborock. Please use it at your own risk.

## Acknowledgments

Thanks to the Tailscale team for their excellent software and to the open-source community for the continuous support.

---

*This project is maintained by [@jahknem](https://github.com/jahknem). For any questions or support, feel free to open an issue or contact me directly.*
