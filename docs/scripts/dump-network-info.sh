#!/bin/bash

# This will get the OS ID for a later conditional logic
source /etc/os-release

# This gets hostname for later use
hostname=$(hostname)

# This gets the current date and time in a particular format so I can use it later  for unique file naming
datetime=$(date +%Y-%m-%d_%H-%M-%S)

# here I am using the file name with hostname, purpose, and timestamp to form a file name os it will be easy to know what it does at a quick glance
file="${hostname}_network_info_${datetime}.txt"

# This function will write each section to the file I created above. For each new section it will sepearted it with "===== $1 =====" for better readabilty
dump_section() {
    echo "===== $1 =====" | tee -a "$file"
    eval "$2" | tee -a "$file"
    echo "" | tee -a "$file"
}

# This is writting a header with hostname and timestamp for the document
echo "Network Information for $hostname on $datetime" | tee "$file"
echo "" | tee -a "$file"

# This is calling the dump fucntion created ealiar to write the IP Address to the file ealiar created "IP Addresses" is the section name ($1) and "ip addr show" is the command ($2)
dump_section "IP Addresses" "ip addr show"

# This will dump the routing table infomation to the file. (paramters are exactly as explained in the ip address section)
dump_section "Routing Table" "ip route show"

#  This will dump the DNS Settings infomation to the file. (paramters are exactly as explained in the ip address section)

dump_section "DNS Settings (/etc/resolv.conf)" "cat /etc/resolv.conf"
if command -v resolvectl >/dev/null 2>&1; then
    dump_section "DNS Status (resolvectl)" "resolvectl status"
fi

#  This will dump the Open ports to the file. (paramters are exactly as explained in the ip address section)
dump_section "Open Ports" "ss -tulpn"

# This will dump the file Firewall Rules to the. I have written the script to work for both ubuntu and my centos stream here so i ran on ubuntu, the ubuntu ufw rules will dumb and same for centos
if command -v ufw >/dev/null 2>&1 && [ "$ID" = "ubuntu" ]; then
    dump_section "Firewall Rules (ufw)" "ufw status verbose"
elif command -v firewall-cmd >/dev/null 2>&1; then
    dump_section "Firewall Rules (firewalld)" "firewall-cmd --list-all"
else
    echo "No known firewall command found" | tee -a "$file"
    echo "" | tee -a "$file"
fi

# this dumps the network innterfaces
dump_section "Network Interfaces" "ip link show"

# this dumps the interface Statistics
dump_section "Interface Statistics" "ip -s link show"

# this will dump network services
for service in systemd-networkd NetworkManager ufw firewalld sshd; do
    if systemctl list-unit-files | grep -q "$service"; then
        dump_section "Service: $service" "systemctl status $service --no-pager"
    fi
done

