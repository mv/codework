
t () {

cd /mnt
tar cf - $1 | (cd /mnt/$2 ; tar xvf -) | tee /mnt/$2/tar_${1}_list.txt
cd /mnt


}

t sda1 pub
t sdb1 pub
# t sdc1 pub2
# t sdc2 pub2

