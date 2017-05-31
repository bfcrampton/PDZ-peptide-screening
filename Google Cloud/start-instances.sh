#!/usr/local/bin/bash

# Simple script to start all 7 instances

declare -A zones

# Setup mapping of researcher # to zone
zones[1]="asia-east1-b"
zones[2]="asia-east1-b"
zones[3]="asia-northeast1-b"
zones[4]="europe-west1-b"
zones[5]="us-central1-b"
zones[6]="us-east1-b"
zones[7]="us-west1-b"

length=${#zones[@]}

for i in `seq 1 $length`; do
	name=researcher$i
	zone=${zones[$i]}

	echo "Starting instance: $name"
	gcloud compute instances start $name --zone=$zone >/dev/null 2>&1 &
done
