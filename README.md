# containerlab - ceosmpls
Arista cEOS MPLS Test in containerlab
![mpls](https://user-images.githubusercontent.com/101124549/159495512-79d6b526-79e0-413d-9cb6-9304e542b005.png)


Sample config and setup, used to test mpls forwarding support in Arista cEOS with containerlab.

The details of the config are the outcome of the Arista [user manual](https://www.arista.com/en/um-eos) and the collaboration in this [thread](https://github.com/srl-labs/containerlab/discussions/807)

## Demo

### Pre-Requisite

+ Install [Docker](https://www.docker.com/)
+ Download cEOS-lab-4.27.2F.tar docker image, from [Arista](https://www.arista.com/) and import in Docker
+ Install [wbitt/network-multitool](https://hub.docker.com/r/wbitt/network-multitool) docker image
+ Install [containerlab](https://containerlab.dev/)

### Clone the repository

```
lab@ubuntu1804:~/clab$ sudo git clone https://github.com/w1nt3rfell/clab-ceosmpls.git
Cloning into 'clab-ceosmpls'...
remote: Enumerating objects: 266, done.
remote: Counting objects: 100% (266/266), done.
remote: Compressing objects: 100% (229/229), done.
remote: Total 266 (delta 32), reused 238 (delta 17), pack-reused 0
Receiving objects: 100% (266/266), 16.94 MiB | 3.65 MiB/s, done.
Resolving deltas: 100% (32/32), done.
lab@ubuntu1804:~/clab$ cd clab-ceosmpls/
lab@ubuntu1804:~/clab/clab-ceosmpls$ ll
total 32
drwxr-xr-x 6 root root 4096 Mar 22 15:40 ./
drwxrwxr-x 7 lab  lab  4096 Mar 22 15:40 ../
-rw-r--r-- 1 root root  633 Mar 22 15:40 ceosmpls.yml
drwxr-xr-x 5 root root 4096 Mar 22 15:40 clab-ceosmpls/
drwxr-xr-x 8 root root 4096 Mar 22 15:40 .git/
drwxr-xr-x 2 root root 4096 Mar 22 15:40 PC1/
drwxr-xr-x 2 root root 4096 Mar 22 15:40 PC3/
-rw-r--r-- 1 root root  476 Mar 22 15:40 README.md
```

### Deploy the lab

```
lab@ubuntu1804:~/clab/clab-ceosmpls$ sudo clab deploy -t ceosmpls.yml
INFO[0000] Containerlab v0.25.0 started
INFO[0000] Parsing & checking topology file: ceosmpls.yml
INFO[0000] Creating lab directory: /home/lab/clab/clab-ceosmpls/clab-ceosmpls
INFO[0000] Creating docker network: Name="clab", IPv4Subnet="172.20.20.0/24", IPv6Subnet="2001:172:20:20::/64", MTU="1500"
INFO[0000] Creating container: "PC1"
INFO[0000] config file '/home/lab/clab/clab-ceosmpls/clab-ceosmpls/R1/flash/startup-config' for node 'R1' already exists and will not be generated/reset
INFO[0000] Creating container: "R1"
INFO[0000] config file '/home/lab/clab/clab-ceosmpls/clab-ceosmpls/R3/flash/startup-config' for node 'R3' already exists and will not be generated/reset
INFO[0000] Creating container: "R3"
INFO[0000] config file '/home/lab/clab/clab-ceosmpls/clab-ceosmpls/R2/flash/startup-config' for node 'R2' already exists and will not be generated/reset
INFO[0000] Creating container: "R2"
INFO[0000] Creating container: "PC3"
INFO[0003] Creating virtual wire: R3:eth3 <--> PC3:eth3
INFO[0004] Creating virtual wire: R1:eth3 <--> PC1:eth3
INFO[0005] Creating virtual wire: R2:eth2 <--> R3:eth2
INFO[0005] Creating virtual wire: R1:eth1 <--> R2:eth1
INFO[0005] Running postdeploy actions for Arista cEOS 'R3' node
INFO[0005] Running postdeploy actions for Arista cEOS 'R1' node
INFO[0005] Running postdeploy actions for Arista cEOS 'R2' node
INFO[0045] Adding containerlab host entries to /etc/hosts file
INFO[0045] 🎉 New containerlab version 0.25.1 is available! Release notes: https://containerlab.dev/rn/0.25/#0251
Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/
+---+------+--------------+-------------------------+-------+---------+----------------+----------------------+
| # | Name | Container ID |          Image          | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+------+--------------+-------------------------+-------+---------+----------------+----------------------+
| 1 | PC1  | 3bb4e24ebc04 | wbitt/network-multitool | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 2 | PC3  | c618bc774a04 | wbitt/network-multitool | linux | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
| 3 | R1   | d5ec388a9a97 | ceos:4.27.2F            | ceos  | running | 172.20.20.6/24 | 2001:172:20:20::6/64 |
| 4 | R2   | fdb0981cbfe5 | ceos:4.27.2F            | ceos  | running | 172.20.20.5/24 | 2001:172:20:20::5/64 |
| 5 | R3   | 4bdbc487b88f | ceos:4.27.2F            | ceos  | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
+---+------+--------------+-------------------------+-------+---------+----------------+----------------------+
lab@ubuntu1804:~/clab/clab-ceosmpls$ 
```

### Ping PC1 to PC3

End to End communication using mpls data-plane.

```
lab@ubuntu1804:~/clab/clab-ceosmpls$ sudo docker exec PC1 ping -c4 192.168.200.1
PING 192.168.200.1 (192.168.200.1) 56(84) bytes of data.
64 bytes from 192.168.200.1: icmp_seq=1 ttl=61 time=25.4 ms
64 bytes from 192.168.200.1: icmp_seq=2 ttl=61 time=29.8 ms
64 bytes from 192.168.200.1: icmp_seq=3 ttl=61 time=25.5 ms
64 bytes from 192.168.200.1: icmp_seq=4 ttl=61 time=25.9 ms

--- 192.168.200.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 25.395/26.671/29.818/1.826 ms
lab@ubuntu1804:~/clab/clab-ceosmpls$
```
