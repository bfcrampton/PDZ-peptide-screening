#!/usr/local/bin/bash

# Script to ssh into any spceific instance. It uses google-cloud API to
# determine its IP address (by name) and creates an SSH connection to it.

# Example (run in this directory): ./ssh-instance.sh 5
# This will ssh into "researcher5"

declare -A zones

echo "Attempting to ssh into researcher$1"

# Setup mapping of researcher # to zone
zones[1]="asia-east1-b"
zones[2]="asia-east1-b"
zones[3]="asia-northeast1-b"
zones[4]="europe-west1-b"
zones[5]="us-central1-b"
zones[6]="us-east1-b"
zones[7]="us-west1-b"

length=${#zones[@]}

i=$1
name=researcher$i
zone=${zones[$i]}

output=$(gcloud compute instances describe $name --zone=$zone)
address=$(echo $output | grep -Eow 'natIP: [0-9\.]+')
address=${address#natIP: }

ssh -o "StrictHostKeyChecking no" $address $2
