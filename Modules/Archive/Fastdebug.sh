#!/bin/bash

date=`date +%d%m%y`

echo "<h4>Backup Errors</h4>"
echo "Fortinet:"
echo "--------------------------------------------------------------------------------------------------"
join <(sort ./Devices/Fortinet/Fortinet-Devices.txt) <(sort ./Log/Fortinet/log$date.txt | grep '\[i]:' | grep -e "not reachable" -e "failed" | sed -e 's/\[i]: //')
join <(sort ./Modules/Backup/Fortinet-Special.sh | grep "#" | grep -v '#!/bin/bash' |  sed 's/# //') <(sort ./Log/Fortinet/log$date.txt| grep '\[i]:' | grep -e "not reachable" -e "failed" | sed -e 's/\[i]: //')
echo "--------------------------------------------------------------------------------------------------"
echo "Cisco:"
echo "--------------------------------------------------------------------------------------------------"
join <(sort ./Devices/Cisco/Cisco-Devices.txt) <(sort ./Log/Cisco/log$date.txt | grep '\[i]:' | grep -e "not reachable" -e "failed" | sed -e 's/\[i]: //')
echo "--------------------------------------------------------------------------------------------------"
#echo "DELL :"
#echo "----------------------------------------------------------------------------"
#cat ./Log/DELL/log$date.txt | grep mv -n |  awk '{print $1}' | cut -f1 -d":"
#echo "----------------------------------------------------------------------------"
#echo "HP :"
#echo "----------------------------------------------------------------------------"
#cat ./Log/HP/log$date.txt | grep mv -n |  awk '{print $1}' | cut -f1 -d":"
