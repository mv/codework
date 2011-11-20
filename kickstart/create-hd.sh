


dvd="/pub/_iso/linux/CentOS-5.7-x86_64-bin-DVD/CentOS-5.7-x86_64-bin-DVD-1of2.iso"
machine_dir="/VMachine"
machine_name="Test01"

mkdir -p ${machine_dir}/${machine_name}

#
# SATA disk: 20G
#
VBoxManage createhd         \
    --filename ${machine_dir}/${machine_name}/${machine_name}.vmdk  \
    --size   20480          \
    --format  VMDK          \
    --variant Standard

VBoxManage storagectl   \
    $machine_name       \
    --name "SATA Controller" \
    --add sata               \
    --controller IntelAhci   \
    --sataportcount 1        \
    --bootable on

VBoxManage storageattach            \
    $machine_name                   \
    --storagectl "SATA Controller"  \
    --port 0             \
    --type hdd --medium ${machine_dir}/${machine_name}/${machine_name}.vmdk

#
# DVD image to boot
#
VBoxManage storagectl       \
    $machine_name           \
    --name "IDE Controller" \
    --add ide               \
    --bootable on

VBoxManage storageattach            \
    $machine_name                   \
    --storagectl "IDE Controller"   \
    --device 1 --port 1             \
    --type dvddrive --medium "$dvd"

