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

