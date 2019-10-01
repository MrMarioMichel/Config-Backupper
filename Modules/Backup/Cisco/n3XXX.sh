#!/bin/bash

user="cisco"
passwd="XXXXXXPASSWORDXXXXXX"

echo "[i]: Started Backup of Configs : Cisco (n3XXX.sh)"

for device in $(egrep -v "^\s*(#|$)" ./Devices/Cisco/Cisco-N3xxx-txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
 do
  echo -e "[i]: Host --> $device"
  if ping -c 3 $device &> /dev/null
   then
    echo "[i]: $device reachable"
    sshpass -p "$passwd" ssh -tt $user@$device <<EOF > BackupConfigCiscoTEMP1 
    terminal length 0
    show startup-config
    exit
EOF
    name=$(grep hostname ./BackupConfigCiscoTEMP1 | sed 's|["?]||g' | sed 's/hostname //' |  tr -dc '[:print:]')
    cat BackupConfigCiscoTEMP1 | grep -v "$name#" > BackupConfigCisco
    if [ -z "$name" ]
     then
      echo "[i]: $device Name not found"
     else
      echo "[i]: $device Name found $name"
      mkdir -v ./Archive/$name
      date=$(date +"%H-%M_%d-%m-%Y")
      mv -v ./BackupConfigCisco ./Archive/$name/$name-$date.conf
      if [ -f ./Archive/$name/$name-$date.conf ]
       then
        echo "[i]: File $name-$date.conf found"
        echo "[i]: $device backup succeeded"
       else
        echo "[i]: File $name-$date.conf not found"
        echo "[i]: $device backup failed"
      fi
    fi
    else
    echo "[i]: $device not reachable"
 fi
done
