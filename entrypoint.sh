#!/bin/bash
# Create disk images if they don't exist
if [ ! -f /storage/windows.qcow2 ]; then
    qemu-img create -f qcow2 /storage/windows.qcow2 "${DISK_SIZE}"
fi
if [ ! -f /storage/windows2.qcow2 ]; then
    qemu-img create -f qcow2 /storage/windows2.qcow2 "${DISK2_SIZE}"
fi

# Start QEMU with parameters from win10.yml
qemu-system-x86_64 \
    -m "${RAM_SIZE}" \
    -smp "${CPU_CORES}" \
    -cpu host \
    -drive file=/storage/windows.qcow2,format=qcow2 \
    -drive file=/storage/windows2.qcow2,format=qcow2 \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -vnc :0 \
    -daemonize

# Keep container running
tail -f /dev/null
