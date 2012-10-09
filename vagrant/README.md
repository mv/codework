
# Exporting a new machine, if the machine has more than one interface:

    sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
    sudo rm -f /etc/sysconfig/network-scripts/ifcfg-eth[1-3]

