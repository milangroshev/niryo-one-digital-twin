#Assuming the disk I want to expand is /dev/sdd and has two partitions /dev/sdd1 and /dev/sdd2, and I want to increase /dev/sdd2
#https://unix.stackexchange.com/questions/231643/increasing-partition-of-a-sd-card

umount /dev/sdd2
sudo parted /dev/sdd resizepart 2 -- -1
sudo e2fsck -f /dev/sdd2
sudo resize2fs /dev/sdd2
