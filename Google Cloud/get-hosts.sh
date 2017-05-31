#!/usr/local/bin/bash

# Run this to generate the Schrödinger hosts file for a given set of GCE
# instances. Paste the output into $SCHRODINGER/schrodinger.hosts text file.

if [ "$EUID" == 0 ]
  then echo "Please DO NOT run this as root"
  exit
fi

declare -A zones
declare -A addresses
declare -A cpu_counts

# Setup mapping of researcher # to zone
zones[1]="asia-east1-b"
cpu_counts[1]=32
zones[2]="asia-east1-b"
cpu_counts[2]=32
zones[3]="asia-northeast1-b"
cpu_counts[3]=64
zones[4]="europe-west1-b"
cpu_counts[4]=64
zones[5]="us-central1-b"
cpu_counts[5]=64
zones[6]="us-east1-b"
cpu_counts[6]=64
zones[7]="us-west1-b"
cpu_counts[7]=64

length=${#zones[@]}

for i in `seq 1 $length`; do
	name=researcher$i
	zone=${zones[$i]}

	output=$(gcloud compute instances describe $name --zone=$zone)
	address=$(echo $output | grep -Eow 'natIP: [0-9\.]+')
	address=${address#natIP: }
	addresses[$i]=$address

	echo "Got host: $name in zone: $zone with IP: $address"
done

# Generate and replace schrodinger.hosts file
host_file=""

for i in `seq 1 $length`; do
	name=researcher$i
	address=${addresses[$i]}
	cpus=${cpu_counts[$i]}

	host_entry="
# $name
name: $name
host: $address
processors: $cpus
tmpdir: /home/bryancrampton/scratch
schrodinger: /home/bryancrampton/schrodinger2017-1
"
	host_file+=$host_entry
done

# Replace hosts file
echo "$host_file"
