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
