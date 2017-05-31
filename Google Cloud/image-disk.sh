#!/usr/local/bin/bash

# Misc. commands to create a custom image of a GCE instance

# Create impage of researcher disk
gcloud compute disks snapshot researcher --snapshot-names researcher
gcloud compute disks create image-researcher --source-snapshot researcher
gcloud compute disks create temporary-disk --size 300GB

# Create imager instance
gcloud compute instances create imager --scopes storage-rw --disk name=image-researcher2,device-name=image-researcher2 --disk name=temporary-disk,device-name=temporary-disk >/dev/null 2>&1 &
gcloud compute ssh imager

# Mount Temporary Disk
sudo mkdir /mnt/tmp
sudo mkfs.ext4 -F /dev/disk/by-id/google-temporary-disk
sudo mount -o discard,defaults /dev/disk/by-id/google-temporary-disk /mnt/tmp

# Create Image
sudo dd if=/dev/disk/by-id/google-image-disk | pv -s 200G | sudo dd of=/mnt/tmp/disk.raw bs=4096
cd /mnt/tmp
sudo -i
tar cf - disk.raw | pv -s `du -sb . | grep -o '[0-9]\+'` -N tar  | gzip > disk.tar.gz

# Upload image to Google Cloud Storage
gsutil mb gs://peptide-research-images # NOW EXISTS DON"T DO AGAIN
gsutil cp ./disk.tar.gz gs://peptide-screening-images/
