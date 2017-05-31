#!/usr/local/bin/bash

# Script to create 7 instances in each zone with maximum allowd CPU cpu counts––
# 528 cores and 2,496GB of RAM!

# These parameters can be altered as required.

declare -A zones
declare -A cpu_counts
declare -A memory_counts

# Setup mapping of researcher # to zone
# This was setup due to cpu quotas by region. It is slightly cheaper to run
# it all within one zone in order to reduce inter-region network costs.

zones[1]="asia-east1-b"
cpu_counts[1]=32
memory_counts[1]=208GiB
zones[2]="asia-east1-b"
cpu_counts[2]=32
memory_counts[2]=208GiB
zones[3]="asia-northeast1-b"
cpu_counts[3]=64
memory_counts[3]=416GiB
zones[4]="europe-west1-b"
cpu_counts[4]=64
memory_counts[4]=416GiB
zones[5]="us-central1-b"
cpu_counts[5]=64
memory_counts[5]=416GiB
zones[6]="us-east1-b"
cpu_counts[6]=64
memory_counts[6]=416GiB
zones[7]="us-west1-b"
cpu_counts[7]=64
memory_counts[7]=416GiB

length=${#zones[@]}

for i in `seq 1 $length`; do
	name=researcher$i
	zone=${zones[$i]}
	cpus=${cpu_counts[$i]}
	memory=${memory_counts[$i]}

	echo "Creating instance: $name in zone: $zone CPUs: $cpus memory: $memory"
	gcloud compute instances create $name --image=researcher-5-9-17 --boot-disk-type=pd-ssd --zone=$zone --custom-cpu=$cpus --custom-memory=$memory &
done
