####################################################################
overdrive use estuary kernel
####################################################################
1.overdrive启动报错问题
思路：
1、estuary kernel修改cmdline，看能否正常开机
2、用linaro配置项测试，看能否开机。
3、裁剪estuary kernel配置项，看能否开机
测试：
1.cmdline add acpi=force boot success.

步骤：
1.copy estuary's kernel Image into boot partition:
mount /dev/sda1 sda
cp Image root/sda/boot/Image

2.add boot menu to grub,note to add "acpi=force" into cmdline

3.reboot

####################################################################
linux container enable in estuary
####################################################################
ubuntu:
1.install packages
apt-get install bridge-utils
apt-get install cloud-utils
apt-get install lxc

2.use "brctl addbr lxcbr0" to add bridge 

3.use lxc-checkconfig & lxc-create & lxc-start test:
use "CONFIG=xxx/.config lxc-checkconfig" check miss configs,and the checkpoint-restore config is not mandatory,so this config miss is ok.
lxc-create -n ubuntu -t ubuntu-cloud -- -r vivid -T http://192.168.1.107/ubuntu-15.04-server-cloudimg-arm64-root.tar.gz

--------------------------------------------------------------------

centos:
can't find lxc package to direct install,so build lxc source code,then install.
1.install packages
yum -y install bridge-utils
yum -y install gcc*
yum -y install cloud-utils
yum -y install libtool
yum -y install wget 
yum -y install debootstrap*
yum -y install libcap-devel

2.get code and build lxc:
git clone git://github.com/lxc/lxc -b master

cd lxc
./autogen.sh 
./configure --enable-tests 
make install

modify /usr/share/lxc/templates/lxc-ubuntu-cloud:
mask this line
#type ubuntu-cloudimg-query

2.use "brctl addbr lxcbr0" to add bridge 

3.use lxc-checkconfig & lxc-create & lxc-start test:
if can't find shared library,reboot,then test again.
use "CONFIG=xxx/.config lxc-checkconfig" check miss configs,and the checkpoint-restore config is not mandatory,so this config miss is ok.
lxc-create -n ubuntu -t ubuntu-cloud -- -r vivid -T http://192.168.1.107/ubuntu-15.04-server-cloudimg-arm64-root.tar.gz

####################################################################
overdrive grub
####################################################################
grub cmdline:
use set to list all env,eg:
prefix=(hd0,gpt1)/EFI/BOOT
prefix is the direct of grub.cfg
by set prefix=(hd0,gpt1)/xxx(the direct of grub.cfg),and then "normal",it will boot success.

overdrive:
[root@cent-est sda]# tree
.
├── EFI
│   └── BOOT
│       ├── bootaa64.efi
│       └── grub.cfg
├── Image
├── mini-rootfs-arm64.cpio.gz
└── startup.nsh


[root@cent-est sda]# cat startup.nsh 
bootaa64


[root@CentOS ~]# efibootmgr 
[  100.758105] efi_call_virt_check_flags: 71 callbacks suppressed
[  100.763947] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.772879] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.781803] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.790725] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.799647] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.808567] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.817624] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.826661] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.835697] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
[  100.844738] efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI get_variable
BootCurrent: 0005
Timeout: 5 seconds
BootOrder: 0005,0006,0004,0001,0000
Boot0000* opensuse-tumbleweed-arm-jeos-efi
Boot0001* Grub
Boot0004  UEFI: Built-in EFI Shell
Boot0005* UEFI: Network Port00
Boot0006* UEFI: Network Port01


grub.cfg:
menuentry 'estuary mini'  --id 'estuary_mini' {
	search --no-floppy --fs-uuid --set=root 85F9-AF34
	linux	/Image plymouth.enable=0 console=ttyAMA0,115200n8  
	initrd	/mini-rootfs-arm64.cpio.gz 
}
menuentry 'centos-estuary nfs'  --id 'centos_nfs' {
	search --no-floppy --fs-uuid --set=root 85F9-AF34
	linux	/Image plymouth.enable=0 console=ttyAMA0,115200n8 root=/dev/nfs rw nfsroot=192.168.1.107:/home/hisilicon/ftp/fengchunsong/Centos,nfsvers=3 ip=dhcp
}
menuentry 'centos-estuary'  --id 'centos' {
	search --no-floppy --fs-uuid --set=root 85F9-AF34
	linux	/Image root=PARTUUID=f62ab48e-b73e-485a-a335-50bb5ae50046     plymouth.enable=0 console=ttyAMA0,115200n8 rootwait rootfstype=ext4 rw 
}

####################################################################
rp1612版本资料
####################################################################
１，uefi仓库和编译方法
编译方法：
$ git clone https://github.com/open-estuary/uefi.git
$ git checkout rp1612
$ git submodule init
$ git git submodule update
$ ./uefi-tools/uefi-build.sh -c LinaroPkg/platforms.config  d03 d05

2, kernel 仓库和编译方法
https://github.com/open-estuary/kbase 验证分支d0x-integration
https://github.com/open-estuary/rpk
https://github.com/hisilicon/kernel-dev

$ make ARCH=arm64 defconfig
$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image -j80

３, caliper仓库
https://github.com/xin3liang/caliper 分支basic-hardware-function
文档：http://open-estuary.org/caliper-benchmarking/
ssh-copy-id -i ~/.ssh/id_rsa.pub root@X.X.X.X

４，参考测试cases
请参看附件
参考plinth 发布的文档，ｈｉ团队：处理器基础软件
linaro tests: https://git.linaro.org/qa/test-definitions.git/

####################################################################
improve network speed 
####################################################################
/etc/sysconfig/network-scripts/ifcfg-eth2: 
NAME=eth2
DEVICE=eth2
ONBOOT=yes
BOOTPROTO=static
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.12.11
NETMASK=255.255.255.0
GATEWAY=192.168.12.1

should not contain the strings mask with #
# Intel Corporation 82545EM Gigabit Ethernet Controller (Copper) 
TYPE=Ethernet #网卡类型 
DEVICE=eth0 #网卡接口名称 
ONBOOT=yes #系统启动时是否自动加载 
BOOTPROTO=static #启用地址协议 --static:静态协议 --bootp协议 --dhcp协议 
IPADDR=192.168.1.11 #网卡IP地址 
NETMASK=255.255.255.0 #网卡网络地址 
GATEWAY=192.168.1.1 #网卡网关地址 
DNS1=10.203.104.41 #网卡DNS地址 
HWADDR=00:0C:29:13:5D:74 #网卡设备MAC地址 
BROADCAST=192.168.1.255 #网卡广播地址 

mind:
------------------------------------------------------------
1.use 4.7 kernel test,should be ok
iperf:
0.0-100.0 sec   110 GBytes  9.41 Gbits/sec

------------------------------------------------------------
2.use 4.9 with 4.7config:test 5.6Gbps

------------------------------------------------------------
3.use 4.9 with 4.7config and hns
[root@CentOS ~]# iperf -s -w 256k
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  448 KByte (WARNING: requested  256 KByte)
------------------------------------------------------------
[  4] local 192.168.12.12 port 5001 connected with 192.168.12.11 port 54368
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-21.8 sec  23.8 GBytes  9.39 Gbits/sec
[root@CentOS ~]# systemctl start irqbalance.service 
[root@CentOS ~]# iperf -s -w 256k
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  448 KByte (WARNING: requested  256 KByte)
------------------------------------------------------------
[  4] local 192.168.12.12 port 5001 connected with 192.168.12.11 port 54370
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-100.0 sec  73.2 GBytes  6.29 Gbits/sec

after few minutes with irqbalance:
0.0-11.7 sec  12.8 GBytes  9.39 Gbits/sec

------------------------------------------------------------
4.estuary_defconfig without crypto and secure options
iperf is not ok,qperf is ok
[root@CentOS ~]# iperf -s -w 256k
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  448 KByte (WARNING: requested  256 KByte)
------------------------------------------------------------
[  4] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58976
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  7.64 GBytes  6.56 Gbits/sec
[  5] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58978
[  5]  0.0-10.0 sec  7.61 GBytes  6.54 Gbits/sec
[  4] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58980
[  4]  0.0-10.0 sec  7.67 GBytes  6.59 Gbits/sec
[  5] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58982
[  5]  0.0-10.0 sec  7.73 GBytes  6.63 Gbits/sec
[  4] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58984
[  4]  0.0-10.0 sec  8.17 GBytes  7.01 Gbits/sec
[  5] local 192.168.12.11 port 5001 connected with 192.168.12.12 port 58986
[  5]  0.0-10.0 sec  8.23 GBytes  7.07 Gbits/sec


5.estuary_defconfig then use zxj private config
iperf not ok


6.common mini config should be ok
iperf ok
qperf min ng,big ok
netperf ok


7.if common is ok,then use common config as base;
  if common not ok,then use zxjallconfig as base.
  check estuary configs,try to find add which configs will cause iperf low performance. 

  1).add estuary all test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ok

  2).add estuary 1-1470 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ng
  2.1).add estuary 1-720 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ng
  2.1.1).add estuary 1-358 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ng
  2.1.2).add estuary 359-720 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ok

  2.2).add estuary 721-1470 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf better
  3).add estuary 1471-2994 test,estuary and zxj diff,use zxj diff.
    iperf/qperf ng
    netperf ok
================================================================
1. zxj:
iperf:ok
qperf:ok
netperf:ok
================================================================
3. est1471-2294:--ok
iperf:ok
qperf:low
netperf:ok
================================================================
2. est1-1470:
iperf:ng
qperf:ok
netperf:ng
================================================================
2.2 est705-1470:--ok
iperf:ok
qperf:ok
netperf:ok
================================================================
2.1 est1-704:
iperf:ng
qperf:ok
netperf:ok
================================================================
2.1.2 est351-704:--ok
iperf:ok
qperf:ok
netperf:ok
================================================================
2.1.1 est1-350:
iperf:ng
qperf:ok
netperf:ng
================================================================
2.1.1.1 est1-175:
iperf:ng
qperf:low
netperf:low
================================================================
2.1.1.2 est176-350:--ok
iperf: ok
qperf: ok
netperf:ok 
================================================================
2.1.1.1.1 est1-87:
iperf: ok
qperf: ok low
netperf: ok

2.1.1.1.1.1 est1-41:
iperf:  ok
qperf:   ok 
netperf:  ok
2.1.1.1.1.2 est42-87:
iperf:  ok
qperf:  ok
netperf: ok 
================================================================
2.1.1.1.1 est88-175:
iperf: ok low
qperf: ok low
netperf: ok
================================================================
4K page
iperf:  ok
qperf:  ok
netperf: ok

================================================================
3. est1-175 64k-->4k:
iperf: ok
qperf: ok
netperf: 
================================================================
iperf server:
    52.76%   +8.89%  [kernel.kallsyms]   [k] __arch_copy_to_user
     3.59%   +0.07%  [kernel.kallsyms]   [k] hns_nic_select_queue
     3.31%   -2.91%  [kernel.kallsyms]   [k] finish_task_switch
     3.05%   -1.20%  [kernel.kallsyms]   [k] skb_copy_datagram_iter
     2.61%   +0.11%  [kernel.kallsyms]   [k] skb_release_data
     1.86%   -0.83%  [kernel.kallsyms]   [k] copy_page_to_iter
     1.86%   -0.57%  [kernel.kallsyms]   [k] tcp_gro_receive
     1.77%   +0.07%  [kernel.kallsyms]   [k] __free_pages_ok
     1.72%   -0.77%  [kernel.kallsyms]   [k] hns_nic_reuse_page.isra.49
     1.63%   -0.37%  [kernel.kallsyms]   [k] __free_page_frag
     1.42%   -0.39%  [kernel.kallsyms]   [k] inet_gro_receive
     1.18%   -0.28%  [kernel.kallsyms]   [k] skb_gro_receive
     1.11%   +0.13%  [kernel.kallsyms]   [k] hns_nic_net_xmit_hw

zdc:
    26.79%   +4.25%  [kernel.kallsyms]   [k] __copy_to_user
     7.03%   -2.13%  [kernel.kallsyms]   [k] hns_nic_rx_poll_one
     6.83%   -1.07%  [kernel.kallsyms]   [k] tcp_gro_receive
     5.32%   -0.46%  [kernel.kallsyms]   [k] __free_page_frag
     5.10%   -0.55%  [kernel.kallsyms]   [k] inet_gro_receive
     4.67%   -0.50%  [kernel.kallsyms]   [k] skb_gro_receive
     3.39%   -0.09%  [kernel.kallsyms]   [k] hns_nic_reuse_page.isra.49
     3.09%   -0.39%  [kernel.kallsyms]   [k] do_csum
     3.00%   -1.11%  [kernel.kallsyms]   [k] dev_gro_receive
     2.77%   -0.25%  [kernel.kallsyms]   [k] kmem_cache_alloc
     2.25%   +0.15%  [kernel.kallsyms]   [k] skb_release_data
     2.23%   -0.31%  [kernel.kallsyms]   [k] kmem_cache_free
     2.02%   -0.22%  [kernel.kallsyms]   [k] __build_skb


iperf client:
    69.08%   +1.62%  [kernel.kallsyms]   [k] __arch_copy_from_user
     3.33%   +0.16%  [kernel.kallsyms]   [k] get_page_from_freelist
     2.57%   -0.21%  [kernel.kallsyms]   [k] tcp_sendmsg
     1.59%   +0.03%  [kernel.kallsyms]   [k] hns_nic_select_queue
     1.14%   +0.12%  [kernel.kallsyms]   [k] skb_page_frag_refill
     0.97%   -0.05%  [kernel.kallsyms]   [k] copy_from_iter
     0.93%   +0.02%  [kernel.kallsyms]   [k] kmem_cache_alloc_node
     0.91%   -0.09%  [kernel.kallsyms]   [k] __alloc_skb
     0.87%   -0.02%  [kernel.kallsyms]   [k] hns_nic_net_xmit_hw
     0.80%   -0.01%  [kernel.kallsyms]   [k] __free_pages_ok
     0.74%   -0.01%  [kernel.kallsyms]   [k] __kmalloc_node_track_caller
     0.67%   -0.36%  [kernel.kallsyms]   [k] __do_softirq
     0.58%   -0.01%  [kernel.kallsyms]   [k] tcp_write_xmit
     0.52%   +0.05%  [kernel.kallsyms]   [k] finish_task_switch
     0.52%   -0.04%  [kernel.kallsyms]   [k] tcp_ack
zdc:
    80.16%   -1.17%  [kernel.kallsyms]   [k] __copy_from_user
     2.96%   -0.18%  [kernel.kallsyms]   [k] tcp_sendmsg
     1.22%   +0.00%  [kernel.kallsyms]   [k] finish_task_switch
     1.22%   -0.18%  [kernel.kallsyms]   [k] copy_from_iter
     1.03%   +0.10%  [kernel.kallsyms]   [k] kmem_cache_alloc_node
     0.96%   +0.01%  [kernel.kallsyms]   [k] get_page_from_freelist
     0.87%   +0.01%  [kernel.kallsyms]   [k] __alloc_skb
     0.66%   -0.02%  [kernel.kallsyms]   [k] skb_page_frag_refill
     0.63%   +0.03%  [kernel.kallsyms]   [k] __kmalloc_node_track_caller
     0.62%   +0.19%  [kernel.kallsyms]   [k] hns_nic_select_queue


qperf server:
    10.01%   -0.06%  [kernel.kallsyms]   [k] __arch_copy_to_user
     8.48%   +0.23%  [kernel.kallsyms]   [k] __local_bh_enable_ip
     7.18%   +0.06%  libc-2.17.so        [.] 0x00000000000a4c54
     6.33%   +0.06%  [kernel.kallsyms]   [k] _raw_spin_lock_bh
     5.48%   +0.47%  [kernel.kallsyms]   [k] skb_copy_datagram_iter
     3.96%   -0.02%  [kernel.kallsyms]   [k] tcp_recvmsg
     3.80%   +0.04%  [kernel.kallsyms]   [k] el0_svc_naked
     3.00%   -0.02%  [kernel.kallsyms]   [k] sock_read_iter
     2.90%   -0.02%  [kernel.kallsyms]   [k] __audit_syscall_exit
     2.83%   -0.02%  [kernel.kallsyms]   [k] __vfs_read
     2.55%   +0.12%  [kernel.kallsyms]   [k] tcp_cleanup_rbuf
     2.19%   -0.10%  [kernel.kallsyms]   [k] fsnotify
     2.08%   +0.11%  [kernel.kallsyms]   [k] copy_page_to_iter

1:
    13.40%   -1.48%  [kernel.kallsyms]  [k] __local_bh_enable_ip
    12.89%   -0.14%  libc-2.17.so       [.] 0x00000000000cbda0
    11.08%   -0.02%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
     7.58%   +0.15%  [kernel.kallsyms]  [k] tcp_cleanup_rbuf
     7.03%   -0.49%  [kernel.kallsyms]  [k] tcp_recvmsg
     5.96%   +0.01%  [kernel.kallsyms]  [k] el0_svc_naked
     3.79%   -0.32%  [kernel.kallsyms]  [k] fsnotify
     3.71%   -0.37%  [kernel.kallsyms]  [k] __audit_syscall_exit
     3.67%   +1.02%  [kernel.kallsyms]  [k] sock_read_iter
     3.35%   +0.06%  [kernel.kallsyms]  [k] __vfs_read
     2.54%   +0.98%  [kernel.kallsyms]  [k] inet_recvmsg
     2.08%   -0.44%  [kernel.kallsyms]  [k] copy_page_to_iter

1 estall:1.58
    11.17%   -0.28%  libc-2.17.so       [.] 0x00000000000cbda0
    10.12%   +0.25%  [kernel.kallsyms]  [k] __local_bh_enable_ip
     8.05%   -0.86%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
     7.07%   +0.63%  [kernel.kallsyms]  [k] __check_object_size
     5.29%   +0.30%  [kernel.kallsyms]  [k] el0_svc_naked
     4.01%   +0.98%  [kernel.kallsyms]  [k] tcp_recvmsg
     3.97%   +0.41%  [kernel.kallsyms]  [k] __vfs_read
     3.31%   +0.12%  [kernel.kallsyms]  [k] __arch_copy_to_user
     3.27%   +0.00%  [kernel.kallsyms]  [k] __audit_syscall_exit
     3.18%   -0.35%  [kernel.kallsyms]  [k] fsnotify
     2.77%   +0.85%  [kernel.kallsyms]  [k] sock_read_iter
     2.74%   +0.24%  [kernel.kallsyms]  [k] tcp_cleanup_rbuf
     2.68%   +0.31%  [kernel.kallsyms]  [k] copy_page_to_iter
     2.60%   -0.06%  [kernel.kallsyms]  [k] security_socket_recvmsg
     2.54%   -1.62%  [kernel.kallsyms]  [k] memblock_is_map_memory
     2.45%   -0.28%  [kernel.kallsyms]  [k] lock_sock_nested


2:
    12.75%   -0.43%  libc-2.17.so       [.] 0x00000000000cbda0
    11.92%   +0.95%  [kernel.kallsyms]  [k] __local_bh_enable_ip
    11.07%   +0.44%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
     7.74%   -1.05%  [kernel.kallsyms]  [k] tcp_cleanup_rbuf
     6.54%   -0.24%  [kernel.kallsyms]  [k] tcp_recvmsg
     5.97%   +0.17%  [kernel.kallsyms]  [k] el0_svc_naked
     4.69%   -0.37%  [kernel.kallsyms]  [k] sock_read_iter
     3.52%   -1.04%  [kernel.kallsyms]  [k] inet_recvmsg
     3.47%   -0.21%  [kernel.kallsyms]  [k] fsnotify
     3.40%   -0.07%  [kernel.kallsyms]  [k] __vfs_read
     3.33%   +0.21%  [kernel.kallsyms]  [k] __audit_syscall_exit


qperf client:
     9.33%   +0.24%  [kernel.kallsyms]   [k] __local_bh_enable_ip
     8.10%   +0.30%  [kernel.kallsyms]   [k] tcp_sendmsg
     8.06%   -0.12%  [kernel.kallsyms]   [k] _raw_spin_lock_bh
     8.01%   -0.80%  [kernel.kallsyms]   [k] __arch_copy_from_user
     6.39%   +0.26%  libc-2.17.so        [.] 0x000000000007ab2c
     4.87%   -0.17%  [kernel.kallsyms]   [k] __audit_syscall_exit
     4.11%   -0.11%  [kernel.kallsyms]   [k] el0_svc_naked
     3.61%   +0.08%  [kernel.kallsyms]   [k] tcp_write_xmit
     3.28%   +0.05%  [kernel.kallsyms]   [k] copy_from_iter
     2.80%   +0.24%  [kernel.kallsyms]   [k] __vfs_write
     2.24%   +0.08%  [kernel.kallsyms]   [k] sock_write_iter
     2.19%   +0.08%  [kernel.kallsyms]   [k] lock_sock_nested
     1.96%   +0.01%  [kernel.kallsyms]   [k] tcp_push


1: 1.92
    13.93%   -0.65%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
    11.95%   +0.47%  libc-2.17.so       [.] 0x00000000000cbe60
    11.47%   -0.81%  [kernel.kallsyms]  [k] __local_bh_enable_ip
     7.39%   +0.41%  [kernel.kallsyms]  [k] tcp_write_xmit
     4.75%   +0.58%  [kernel.kallsyms]  [k] el0_svc_naked
     4.63%   -0.70%  [kernel.kallsyms]  [k] tcp_push
     4.47%   -0.76%  [kernel.kallsyms]  [k] tcp_sendmsg
     3.93%   -0.34%  [kernel.kallsyms]  [k] __audit_syscall_exit
     3.03%   +0.33%  [kernel.kallsyms]  [k] lock_sock_nested
     2.80%   -0.75%  [kernel.kallsyms]  [k] vfs_write
     2.57%   -0.57%  [kernel.kallsyms]  [k] __vfs_write
     2.33%   +1.23%  [kernel.kallsyms]  [k] copy_from_iter
     2.19%   +0.10%  [kernel.kallsyms]  [k] unroll_tree_refs
     2.06%   -0.15%  [kernel.kallsyms]  [k] inet_sendmsg
     1.87%   -0.29%  [kernel.kallsyms]  [k] __tcp_push_pending_frames
     1.67%   +0.45%  [kernel.kallsyms]  [k] sock_write_iter
     1.61%   +0.45%  [kernel.kallsyms]  [k] release_sock
     1.59%   +0.32%  [kernel.kallsyms]  [k] syscall_trace_exit
     1.27%   +0.03%  [kernel.kallsyms]  [k] ret_to_user

ubuntu:1.86
    13.21%   +1.22%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
    12.18%   +0.02%  [kernel.kallsyms]  [k] __local_bh_enable_ip
    11.65%   +0.42%  libc-2.23.so       [.] 0x00000000000ba2c0
     9.13%   +0.24%  [kernel.kallsyms]  [k] tcp_sendmsg
     7.35%   -0.07%  [kernel.kallsyms]  [k] tcp_write_xmit
     6.84%   +0.39%  [kernel.kallsyms]  [k] copy_from_iter
     5.61%   -0.05%  [kernel.kallsyms]  [k] el0_svc_naked
     3.16%   +0.05%  [kernel.kallsyms]  [k] tcp_push
     3.14%   -1.04%  [kernel.kallsyms]  [k] lock_sock_nested
     2.57%   -0.72%  [kernel.kallsyms]  [k] fsnotify
     1.79%   -0.46%  [kernel.kallsyms]  [k] __arch_copy_from_user
     1.78%   +0.05%  [kernel.kallsyms]  [k] __tcp_push_pending_frames
     1.74%   -0.09%  [kernel.kallsyms]  [k] release_sock
     1.73%   +0.09%  [kernel.kallsyms]  [k] sock_write_iter


1 estall:1.54
    10.87%   -1.87%  libc-2.17.so       [.] 0x00000000000cbe60
     9.19%   +0.54%  [kernel.kallsyms]  [k] tcp_sendmsg
     8.71%   +0.73%  [kernel.kallsyms]  [k] __local_bh_enable_ip
     7.23%   -0.45%  [kernel.kallsyms]  [k] _raw_spin_lock_bh
     6.85%   -0.00%  [kernel.kallsyms]  [k] __check_object_size
     4.73%   -0.22%  [kernel.kallsyms]  [k] tcp_write_xmit
     3.90%   -0.14%  [kernel.kallsyms]  [k] __arch_copy_from_user
     3.63%   -0.05%  [kernel.kallsyms]  [k] copy_from_iter
     3.41%   +0.33%  [kernel.kallsyms]  [k] el0_svc_naked
     3.18%   -0.33%  [kernel.kallsyms]  [k] __vfs_write
     2.77%   -0.40%  [kernel.kallsyms]  [k] memblock_is_map_memory
     2.45%   +1.07%  [kernel.kallsyms]  [k] __audit_syscall_exit
     2.45%   -0.54%  [kernel.kallsyms]  [k] lock_sock_nested
     2.42%   +0.09%  [kernel.kallsyms]  [k] sock_write_iter


2: 3.84
    11.96%   +1.04%  [ker 3.84nel.kallsyms]  [k] _raw_spin_lock_bh
    10.99%   -0.84%  [kernel.kallsyms]  [k] __local_bh_enable_ip
    10.20%   +1.83%  libc-2.17.so       [.] 0x00000000000cbe60
     6.84%   -2.94%  [kernel.kallsyms]  [k] __audit_syscall_exit
     6.47%   +2.08%  [kernel.kallsyms]  [k] tcp_write_xmit
     5.95%   -0.87%  [kernel.kallsyms]  [k] tcp_sendmsg
     5.36%   -2.85%  [kernel.kallsyms]  [k] __vfs_write
     5.28%   -0.36%  [kernel.kallsyms]  [k] tcp_push
     4.60%   +0.92%  [kernel.kallsyms]  [k] el0_svc_naked
     4.18%   -1.47%  [kernel.kallsyms]  [k] vfs_write
     2.02%   +0.15%  [kernel.kallsyms]  [k] release_sock


####################################################################
single level:
[root@CentOS ~]# systemctl list-units --type=service
  UNIT                        LOAD   ACTIVE SUB     DESCRIPTION
  kmod-static-nodes.service   loaded active exited  Create list of required stat
  rescue.service              loaded active running Rescue Shell
  rhel-readonly.service       loaded active exited  Configure read-only root sup
  systemd-journal-flush.service loaded active exited  Flush Journal to Persisten
  systemd-journald.service    loaded active running Journal Service
  systemd-random-seed.service loaded active exited  Load/Save Random Seed
  systemd-sysctl.service      loaded active exited  Apply Kernel Variables
  systemd-tmpfiles-setup-dev.service loaded active exited  Create Static Device 
● systemd-tmpfiles-setup.service loaded failed failed  Create Volatile Files and
  systemd-udev-trigger.service loaded active exited  udev Coldplug all Devices
  systemd-udevd.service       loaded active running udev Kernel Device Manager
  systemd-update-utmp.service loaded active exited  Update UTMP about System Boo
  systemd-vconsole-setup.service loaded active exited  Setup Virtual Console



####################################################################
update kernel and modules
####################################################################
mount /dev/sda1 /mnt
rm -f /mnt/Image_dbg

rm -rf /lib/modules/4.9*
rm -rf /lib/firmware


cp out/binary/Image /mnt/Image_dbg
cp out/modules/lib/firmware /lib/ -a
cp out/modules/lib/modules/* /lib/modules -a

ll /mnt/Image_*
ls /lib/firmware
ls /lib/modules/
rm -rf out
sync

####################################################################
 CMA:
####################################################################	
D05:
[root@CentOS ~]# free -g
              total        used        free      shared  buff/cache   available
Mem:             63           4          59           0           0          54
Swap:             0           0           0

[    0.000000] Memory: 535966656K/536604608K available (10812K kernel code, 2042K rwdata, 4608K rodata, 1472K init, 7490K bss, 637952K reserved, 0K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
[    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7bdfffff0000   (126847 GB)
[    0.000000]       .text : 0xffff000008080000 - 0xffff000008b10000   ( 10816 KB)
[    0.000000]     .rodata : 0xffff000008b10000 - 0xffff000008fa0000   (  4672 KB)
[    0.000000]       .init : 0xffff000008fa0000 - 0xffff000009110000   (  1472 KB)
[    0.000000]       .data : 0xffff000009110000 - 0xffff00000930ea00   (  2043 KB)
[    0.000000]        .bss : 0xffff00000930ea00 - 0xffff000009a5f4f0   (  7491 KB)
[    0.000000]     fixed   : 0xffff7fdffe7d0000 - 0xffff7fdffec00000   (  4288 KB)
[    0.000000]     PCI I/O : 0xffff7fdffee00000 - 0xffff7fdfffe00000   (    16 MB)
[    0.000000]     vmemmap : 0xffff7fe000000000 - 0xffff800000000000   (   128 GB maximum)
[    0.000000]               0xffff7fe000000000 - 0xffff7fe117ff0000   (  4479 MB actual)
[    0.000000]     memory  : 0xffff800000000000 - 0xffff845ffc000000   (4587456 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=64

[root@CentOS ~]# cat /proc/buddyinfo
Node 0, zone      DMA     22      9     15     13     11      9      6      6      4      5      5      2      0      0 
Node 0, zone   Normal      5      9     16      5      3      2      1      2      2      1      2      2      1    250 
Node 1, zone   Normal     29     25     19      9      6      3      0      1      2      2      3      2      1    252 
Node 2, zone   Normal     33     86     31     11      6      1      2      1      1      2      2      3      1    253 
Node 3, zone   Normal     74     95    117     66     43     29     20     16      7     11      6      6      1    237

[root@CentOS ~]# cat /proc/ioports 
00000000-0000ffff : PCI Bus 0002:80
  000000e4-000000e4 : ipmi_si
  000000e5-000000e5 : ipmi_si
  000000e6-000000e6 : ipmi_si
  000002f8-000002ff : serial
00010000-0001ffff : PCI Bus 0004:88
00020000-0002ffff : PCI Bus 0005:00
00030000-0003ffff : PCI Bus 0006:c0
00040000-0004ffff : PCI Bus 0007:90
00050000-0005ffff : PCI Bus 000a:10
00060000-0006ffff : PCI Bus 000c:20
00070000-0007ffff : PCI Bus 000d:30


D03：
[root@CentOS ~]# cat /proc/ioports 
00000000-0000ffff : PCI Bus 0000:00
  000000e4-000000e4 : ipmi_si
  000000e5-000000e5 : ipmi_si
  000000e6-000000e6 : ipmi_si
  000002f8-000002ff : serial
00010000-0001ffff : PCI Bus 0001:e0
00020000-0002ffff : PCI Bus 0002:80
  00020000-00021fff : PCI Bus 0002:81
    00020000-00021fff : PCI Bus 0002:82
      00020000-00020fff : PCI Bus 0002:83
      00021000-00021fff : PCI Bus 0002:84

[root@CentOS ~]# cat /proc/buddyinfo
Node 0, zone      DMA      7      6      9      8      5      7      7      5      6      3      2      2      1      0 
Node 0, zone   Normal     14     22     19      6      4      4      0      3      2      4      3      4      2    114

D03:
[root@centos ~]# free -g
              total        used        free      shared  buff/cache   available
Mem:            511           5         505           0           0         466
Swap:             0           0           0

[    0.000000] Memory: 66939264K/67104704K available (9852K kernel code, 1678K rwdata, 4800K rodata, 1216K init, 7232K bss, 165440K reserved, 0K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
[    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7bdfffff0000   (126847 GB)
[    0.000000]       .text : 0xffff000008080000 - 0xffff000008a20000   (  9856 KB)
[    0.000000]     .rodata : 0xffff000008a20000 - 0xffff000008ee0000   (  4864 KB)
[    0.000000]       .init : 0xffff000008ee0000 - 0xffff000009010000   (  1216 KB)
[    0.000000]       .data : 0xffff000009010000 - 0xffff0000091b3a00   (  1679 KB)
[    0.000000]        .bss : 0xffff0000091b3a00 - 0xffff0000098c3b60   (  7233 KB)
[    0.000000]     fixed   : 0xffff7fdffe7d0000 - 0xffff7fdffec00000   (  4288 KB)
[    0.000000]     PCI I/O : 0xffff7fdffee00000 - 0xffff7fdfffe00000   (    16 MB)
[    0.000000]     vmemmap : 0xffff7fe000000000 - 0xffff800000000000   (   128 GB maximum)
[    0.000000]               0xffff7fe000000000 - 0xffff7fe00c000000   (   192 MB actual)
[    0.000000]     memory  : 0xffff800000000000 - 0xffff803000000000   (196608 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1

D03:
[    0.000000] cma: Reserved 256 MiB at 0x0000000021c00000
00026000-31c0ffff : System RAM

D05:
[    0.000000] cma: Reserved 256 MiB at 0x0000000021800000
00026000-31aaffff : System RAM

D05     D03
fail 	ok
fail 	ok
D05+82599:-2016
CmaTotal:         262144 kB
CmaFree:          244192 kB

D05:
CmaTotal:         262144 kB
CmaFree:          246208 kB

D03:
CmaTotal:         262144 kB
CmaFree:          254180 kB




4488
1991



