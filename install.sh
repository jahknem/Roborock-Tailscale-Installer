#!/bin/ash
# Starting the Tailscale installation script.

# Step 1: Determine the CPU architecture of the current system.
cpu_type=$(uname -m)
echo "Detected CPU architecture: $cpu_type"

# Step 2: Translate the CPU architecture into a format recognized by Tailscale's download URLs.
case "$cpu_type" in
    x86_64)
        tailscale_arch="amd64"
        ;;
    i386|i686)
        tailscale_arch="386"
        ;;
    armv6l|armv7l)
        tailscale_arch="arm"
        ;;
    aarch64|armv8l)
        tailscale_arch="arm64"
        ;;
    mips)
        tailscale_arch="mips"
        ;;
    mips64)
        tailscale_arch="mips64"
        ;;
    mips64el)
        tailscale_arch="mips64le"
        ;;
    mipsel)
        tailscale_arch="mipsle"
        ;;
    riscv64)
        tailscale_arch="riscv64"
        ;;
    *)
        echo "Unsupported architecture: $cpu_type"
        exit 1
        ;;
esac
echo "Translated architecture for Tailscale: $tailscale_arch"

# Step 3: Define the Tailscale version to download and construct the URL.
tailscale_version="1.52.1"
download_url="https://pkgs.tailscale.com/stable/tailscale_${tailscale_version}_${tailscale_arch}.tgz"
echo "Download URL set: $download_url"

# Step 4: Download the Tailscale package to /tmp directory.
echo "Downloading Tailscale package..."
wget -O /tmp/tailscale.tgz "$download_url" --no-check-certificate && echo "Download complete."

# Step 5: Extract the downloaded package.
echo "Extracting package..."
tar -C /tmp -xzf /tmp/tailscale.tgz && echo "Extraction complete."

# Step 6: Copy the Tailscale binaries to /usr/local/bin.
echo "Copying binaries to /usr/local/bin..."
cp /tmp/tailscale/tailscale /tmp/tailscale/tailscaled /usr/local/bin/ && echo "Binaries copied."

# Step 7: Ensure the persistent state directory exists.
echo "Checking for persistent state directory..."
if [ ! -d /mnt/data/tailscale ]; then
    echo "Directory doesn't exist. Creating directory..."
    mkdir -p /mnt/data/tailscale
    echo "Directory created."
else
    echo "Directory already exists. Skipping creation."
fi

# Step 8: Add the Tailscaled service to startup via rc.local, if not already added.
echo "Configuring Tailscaled to start on boot..."
if ! grep -Fq "start-stop-daemon -S -b -x /usr/local/bin/tailscaled -- --state=/mnt/data/tailscale/tailscaled.state" /etc/rc.local; then
    echo "Backing up rc.local before modifications..."
    cp /etc/rc.local /etc/rc.local.backup && echo "Backup created: rc.local.backup"
    echo "Adding Tailscaled to rc.local..."
    sed -i '/^exit 0$/i start-stop-daemon -S -b -x /usr/local/bin/tailscaled -- --state=/mnt/data/tailscale/tailscaled.state' /etc/rc.local
    echo "Tailscaled added to rc.local."
else
    echo "Tailscaled is already configured to start on boot."
fi

# Step 9: Start the Tailscale daemon.
echo "Starting Tailscale daemon..."
start-stop-daemon -S -b -x /usr/local/bin/tailscaled -- --state=/mnt/data/tailscale/tailscaled.state
echo "Tailscale daemon started."

echo "Tailscale installation script has completed."
