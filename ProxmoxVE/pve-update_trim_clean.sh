#!/bin/bash
sleep 1
echo Updating LXC:
read -p "Press Enter to continue...."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/drescher-manu/Scripts/main/ProxmoxVE/tools/pve/update-lxcs.sh)"
sleep 1
echo Cleaning LXC:
echo apt-get --purge autoremove + autoclean
echo + deleting content of /var/lib/apt/lists/ + updating apt package list
echo
read -p "Press Enter to continue...."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/drescher-manu/Scripts/main/ProxmoxVE/tools/pve/clean-lxcs.sh)"
sleep 1
echo Trimming Filesystem on LXC and the executed Node:
read -p "Press Enter to continue...."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/drescher-manu/Scripts/main/ProxmoxVE/tools/pve/fstrim.sh)"
sleep 1
echo Removing old and unused Kernels on executed Node:
read -p "Press Enter to continue...."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/drescher-manu/Scripts/main/ProxmoxVE/tools/pve/kernel-clean.sh)"
sleep 1
echo Finished!
read -p "Press Enter to exit...."
