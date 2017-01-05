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
xxxxx
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

