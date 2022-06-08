#!/bin/bash
echo "-- Setup predictable interface name (eth0)"
MAC=$(cat /sys/class/net/eth0/address)
touch /etc/udev/rules.d/70-persistent-net.rules
echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$MAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"eth0\"" > /etc/udev/rules.d/70-persistent-net.rules
echo "...written to /etc/udev/rules.d/70-persistent-net.rules"
echo ""

echo "-- Configuring static ip"
echo "provide your static ip with mask (like 192.168.1.2/24)"
read ip4
echo "provide your gateway"
read gateway
read -e -p "provide your dns servers, space separated:" -i "8.8.8.8 8.8.4.4" dnsservers

>/etc/dhcpcd.conf

cat <<EOF > /etc/dhcpcd.conf
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option interface_mtu
require dhcp_server_identifier
slaac private
interface eth0
EOF

echo "  static ip_address=$ip4/24" >> /etc/dhcpcd.conf
echo "  static ip6_address=fd51:42f8:caae:d92e::ff/64" >> /etc/dhcpcd.conf
echo "  static routers=$gateway" >> /etc/dhcpcd.conf
echo "  static domain_name_servers=$dnsservers" >> /etc/dhcpcd.conf
echo "...written to /etc/dhcpcd.conf"

echo ""
echo "Network config done, reboot your raspberry pi"

