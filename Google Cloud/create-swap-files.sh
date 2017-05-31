#!/usr/local/bin/bash

# Swapfiles use physical disk space (preferably SSD) as virtual RAM. This
# prevents crashing when the memory overflows––a probelm for Glide jobs but not
# Prime MMGBSA jobs.

# Run these commands on each instance to create a swapfile for virtual memory

# Create swapfile
sudo fallocate -l 150G /swapfile

sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s


# Remove Swap File
sudo swapoff /swapfile
sudo rm /swapfile
