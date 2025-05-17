# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install QEMU, KVM, and networking dependencies
RUN apt-get update && apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    virtinst \
    bridge-utils \
    curl \
    unzip \
    net-tools \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directories for storage and scripts
RUN mkdir -p /storage /app

# Set environment variables from win10.yml
ENV VERSION="10" \
    USERNAME="USERNAME" \
    PASSWORD="PASSWORD" \
    RAM_SIZE="4G" \
    CPU_CORES="4" \
    DISK_SIZE="400G" \
    DISK2_SIZE="100G"

# Copy entrypoint script to start the VM
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose ports from win10.yml
EXPOSE 8006 3389

# Mount volume for persistent storage
VOLUME ["/storage"]

# Entrypoint to start the Windows VM
CMD ["/app/entrypoint.sh"]
