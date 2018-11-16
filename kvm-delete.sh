#!/bin/bash
[[ "$1" == "-h" || "$1" == "--help" || $# = 0 ]] && echo "Usage $(basename $0) delete domain " && exit
! virsh list --all|awk '{print $2}'|grep "^$1$" > /dev/null && echo "Domain "$1" is not exist" && exit
virsh destroy $1 &> /dev/null
####删除快照
num=$(virsh snapshot-list $1|grep ".snap"|wc -l)
i=1
while [ $i -le $num ];do 
	virsh  snapshot-delete  $1 --current > /dev/null
	let i++
done
####删除虚拟机
disk_dir="/var/lib/libvirt/images"
xml_dir="/etc/libvirt/qemu"
read -p "If you would to delete $1 ?  (yes/no): " choise
[ "$choise" != "yes" ] && exit
virsh undefine $1 > /dev/null
rm -rf $disk_dir/$1.qcow2
rm -rf $xml_dir/$1.xml
