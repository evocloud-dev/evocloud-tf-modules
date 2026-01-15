#cloud-config
package_update: true

packages:
  - iptables
  - iptables-services

write_files:
  - path: /etc/NetworkManager/dispatcher.d/ifup-local
    content: |
      #!/bin/sh
      /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
      /sbin/iptables -t nat -A POSTROUTING -s '${vpc_cidr}' -o eth0 -j MASQUERADE
    permissions: '0755'

runcmd:
  - reboot