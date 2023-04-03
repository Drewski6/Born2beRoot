######################################################
# Example output from subject for Broadcast message
######################################################

#Architecture: Linux wil 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux
#CPU physical : 1
#vCPU : 1
#Memory Usage: 74/987MB (7.50%)
#Disk Usage: 1009/2Gb (39%)
#CPU load: 6.7%
#Last boot: 2021-04-25 14:45
#LVM use: yes
#Connections TCP : 1 ESTABLISHED
#User log: 1
#Network: IP 10.0.2.15 (08:00:27:51:9b:a5)
#Sudo : 42 cmd

######################################################
# Helper Variables / Calculations
######################################################

# returns number of total available MB in memory.
MEM_TOTAL=$(free -m | awk '/^Mem/{print $2}')
# returns number of used MB in memory.
MEM_USED=$(free -m | awk '/^Mem/{print $3}')
# bc -l (CL calculator. -l outputs float) pipe to awk and use printf with .2f to trim.
MEM_PERC=$(bc -l <<< "$MEM_USED / $MEM_TOTAL * 100" | awk '{printf("%.2f", $1)}')
# returns megabytes used on disk.
DISK_USED_MB=$(bc <<< "$(df --total | awk '/total/{print $3}') / 1000")
# returns megabytes available on disk.
DISK_TOTAL_MB=$(bc <<< "$(df --total | awk '/total/{print $4}') / 1000")
# returns gigabytes available on disk
DISK_TOTAL_GB=$(bc -l <<< "$DISK_TOTAL_MB / 1000" | awk '{printf("%.1f", $1)}')
# use bc (like in above mem calculation) to determine percentage of disk used.
DISK_PERC=$(bc -l <<< "$DISK_USED_MB / $DISK_TOTAL_MB * 100" | awk '{printf("%.2f", $1)}')
# returns number of times lvm is mentioned in lsblk.
LVM_USE=$(lsblk | awk '/lvm/{print}' | wc -l)
# returns number of commands executed with 'sudo'.
SUDO_NUM=$(cat /var/log/sudo/sudo.log | awk '/COMMAND/{print}' | wc -l)

######################################################
# Wall Command and associated functions.
######################################################

wall "\
#Architecture   : `uname -a`
#CPU physical   : `awk '/^physical id/{print $3}' /proc/cpuinfo | uniq | wc -l`
#vCPU           : `awk '/^processor/{print $3}' /proc/cpuinfo | uniq | wc -l`
#Memory Usage   : `echo $MEM_USED"/"$MEM_TOTAL"MB ("$MEM_PERC"%)"`
#Disk Usage     : `echo $DISK_USED_MB"/"$DISK_TOTAL_GB"Gb ("$DISK_PERC"%)"`
#CPU load       : `echo $(top -bn1 | awk '/^%Cpu/{printf("%.1f", ($2 + $4))}')"%"`
#Last boot      : `uptime --since`
#LVM use        : `if [ $LVM_USE -gt 0 ]; then echo yes; else echo no; fi`
#Connections TCP: `echo $(ss -re | awk '/tcp/{print}' | wc -l) "ESTABLISHED"`
#User log       : `users | wc -w`
#Network        : `echo "IP" $(hostname -I) "("$(ip a | awk '/ether/{print $2}')")"`
#Sudo           : `echo $SUDO_NUM cmd`"

