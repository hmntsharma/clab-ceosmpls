ip route del default dev eth0
ip addr add 192.168.100.1/30 dev eth3
ip route add default via 192.168.100.2 dev eth3

