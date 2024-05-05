## get interface name (ovs_eth0 below) via ip link
ip link add macvlan0 link bond0 type macvlan mode bridge
##10.0.1.20/30 (20-203)
ip addr add 10.0.1.20/30 dev macvlan0
ip link set macvlan0 up
ip route add 10.0.1.20/30 dev macvlan0