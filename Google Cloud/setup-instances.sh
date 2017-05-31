#!/usr/local/bin/bash

# Script to create a VNC ssh tunnel (port 5901) as well as tunnels on ports
# 27008 and 53000 for schrodinger license traffic.

if [ "$EUID" == 0 ]
  then echo "Please DO NOT run this as root"
  exit
fi

declare -A zones
declare -A addresses

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

	output=$(gcloud compute instances describe $name --zone=$zone)
	address=$(echo $output | grep -Eow 'natIP: [0-9\.]+')
	address=${address#natIP: }
	addresses[$i]=$address

	echo "Setting up: $name in zone: $zone with IP: $address"

	# Start vncserver on remote host
	ssh -o "StrictHostKeyChecking no" username@$IP.ADDRESS vncserver
	# Open local SSH tunnel for vnc traffic from local host to port 5901 on remote
	# Local port is: research{i} on port 590{i}. Ex: researcher5 is on locahost:5905
	ssh -L 590$i:127.0.0.1:5901 -Nf -l username $address

	# Create reverse SSH tunnel for license traffic through admin computer (local)
	ssh -o "StrictHostKeyChecking no" -nfNT -R 27008:LICENSE_SERVER_URL:27008 -R 53000:LICENSE_SERVER_URL:53000 username@$IP.ADDRESS
done

echo "Starting /etc/hosts file monitoring (changed by Schrodinger ruins SSH tunnel licensing)"
# exec sudo ./monitor-hosts-file.sh # Only if necessary for the specific license
# server
