#!/bin/bash
linuxPartition=$(fdisk -l|grep "filesystem"|grep -E -o '/dev/[a-zA-Z]{3}[0-9]{1}')
efiPartition=$(echo "/dev/sda1")

mount $linuxPartition /mnt
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
mount --bind /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars
mkdir /mnt/boot/efi
mount $efiPartition /mnt/boot/efi
mount -o remount,rw $efiPartition /mnt/boot/efi
mkdir /mnt/hostrun
mount --bind /run /mnt/hostrun
chroot /mnt
mkdir /run/lvm
mount --bind /hostrun/lvm /run/lvm
grub-install /dev/sda
update-grub
exit
umount /mnt/dev
umount /mnt/proc
umount /mnt/sys
umount /mnt/sys/firmware/efi/efivars
umount /mnt/boot/efi
umount /mnt/hostrun
umount /mnt/run/lvm
umount /mnt
REBOOT