#!/usr/local/bin/bash

# *hacky* way to ensure that your /etc/hosts file remains intact to the original
# state. Schodinger sometimes changes it to route the license to server to
# localhost, which does not work with the SSH tunneling. This may be a specific
# issue with the VPN client used during my work––neither Dartmouh nor DHMC.

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

i=0

while : ; do
	((i++))

	hosts="$(cat /etc/hosts)"
	hosts_bak="$(cat /etc/hosts.bak)"

	if [ "$hosts" == "$hosts_bak" ]
		then
		if [ $i == 50 ]
			then
			i=0
			echo "No change..."
		fi
		else
			echo "Host file changed...updating from backup"
			echo "Changed host file:"
			echo "$hosts"
			cat /etc/hosts.bak > /etc/hosts
			echo "Updated to:"
			echo "$hosts_bak"
	fi

	sleep 3
done
