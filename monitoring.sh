# Collect info

# arch and kernel
arch=$(uname --all)

# physical and virtual cpus
f_cpu=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
v_cpu=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)

# ram
ram_aval=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_usage=$(free -m | awk '$1 == "Mem:" {print $3}')
ram_perc=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# disk
disk_aval=$(df -Bm --total | awk '$1 == "total" {print $2}' | cut -c -4)
disk_usage=$(df -Bm --total | awk '$1 == "total" {print $3}' | cut -c -4)
disk_perc=$(df -h --total | awk '$1 == "total" {print $5}')

# cpu
cpu_usage=$(mpstat | awk '/all/ {printf "%.2f", 100 - $NF}')

# last boot
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# lvm usage
lvm=$(lsblk | grep "lvm" | wc -l)
lvm_a=$(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)

# conections tcp:
conections=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')

# users in server
users_server=$(users | wc -w)

# ip and mac
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

# sudos used
sudo_usage=$(cat /var/log/sudo/sudo.log | wc -l | tr '\n' ' ')



# -------------------------------------------------------------------------------------------
# Print info into terminals

wall -n "

-Architecture: $arch
-Physical Processors: $f_cpu
-Virtual Processors: $v_cpu
-RAM avaliable and utilization rate: $ram_usage / $ram_aval MB ($ram_perc%)
-Disk usage and utilization rate: $disk_usage / $disk_aval MB ($disk_perc)
-CPU usage rate: $cpu_usage %
-Last boot: $last_boot
-LVM active?: $lvm_a
-Number of active connections: $conections
-Number of users in server: $users_server
-IPv4 and MAC: IP $ip - MAC $mac
-How much Sudo comands was been used: $sudo_usage

"
