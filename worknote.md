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



