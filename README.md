[![Codacy Badge](https://api.codacy.com/project/badge/Grade/4a40b08c61e64e598dca919d22a9eee5)](https://app.codacy.com/app/MrMarioMichel/Config-Backupper?utm_source=github.com&utm_medium=referral&utm_content=MrMarioMichel/Config-Backupper&utm_campaign=Badge_Grade_Dashboard)

# Config-Backupper

This script can backup the configs from firewalls and switches.

| Vendor        | Operational |
| :------------- |:------------
| Fortinet   | For fortigateX series |
| DELL       | For nXXXX series |
| Cisco      | For sgX00 & n3XXX & wsc3650 series |
| HP         |                  |


### Packet dependencies
Check the file **REQUIREMENTS** to see all packet dependencies.

# How to install 
Step 1. ``` git clone https://github.com/MrMarioMichel/Config-Backupper ```  --> this branch should work otherwise download one of  the [newest release](https://github.com/MrMarioMichel/Config-Backupper/releases)

Step 2. ```cd ./Config-Backupper``` --> enter the downloaded repository

Step 3. ```chmod 700 ./setup.sh``` --> make the setup.sh executable

Step 4. ```./setup.sh``` --> start the setup.sh

# How to setup

#### Set days after a config gets compressed (.gz format) [2,5x-3,5x SMALLER] (Numbers only):

Here you can define (in days) when the archived configs get compressed*. (Recommended : 14)


#### Set days after a config gets deleted (Numbers only):

Here you can define (in days) when the archived configs get deleted*. (Recommended : 90)


#### Set days after a logs gets compressed (.gz format) [2,5x-3,5x SMALLER] (Numbers only):

Here you can define (in days) when the archived logs get compressed*. (Recommended : 14)


#### Set days after a logs gets deleted (Numbers only):

Here you can define (in days) when the archived logs get deleted*. (Recommended : 90)


*If you don't want to deleted/commpress the configs/logs is set it to 9999. --> No compression/deletion for 27 Years long enough...

#### Enter bit lenth (Numbers only):

Here you can define the SSH Key used to authenticate at the devices. (Recommended : 4096 or higher)

Use low bit key length (1024 - 2048bits) to speed up the authentication **BUT SECURITY SUFFERS FROM IT !!!**.

#### Enter passphrase (empty for no passphrase):

Just press enter otherwise the script would need everytime it connects to a devices the password. Still want to have a password you will neeed to enter the password in clear text in the ./Modules/Backup/\<VENDOR>/\<MODUDLE>.sh module ```sshpass -p "<PASSWORD>" scp -i ./SSH-Keys/Backup-SSH-Key backup@<IP>:<CONFIGFILE>  ./TestConfigFile```

#### Enter same passphrase again:

Again just enter.

### OPTIONAL Setup

#### Hook ./Archive to a website 

Launch ./Modules/Setup/WebsiteIndex.sh to hook up the Archive folder to the webserver directory.

#### Mail of Firmware-Versions (Fortinet)

Create a crontab with ...

```0 9 1 * * echo "Generated by FirmwareChecker.sh" | mailx -s "Firmware Versions $(date +"%d-%m-%Y")" -r <SENDER-EMAIL-ADDRESS> -S smtp="<MAIL-SERVER-IP-OR-DOMAIN>:25" -a /<ABSOLUTE-PATH>/Config-Backupper/Devices/Firmware-Versions/Fortinet-Firmware-Versions.txt -a /<ABSOLUTE-PATH>/Config-Backupper/Devices/Firmware-Versions/Fortinet-Firmware-Count.txt <REZIPIENT-EMAIL-ADDRESS>```

e.g.

```0 9 1 * * echo "Generated by FirmwareChecker.sh" | mailx -s "Firmware Versions $(date +"%d-%m-%Y")" -r config-backupper@mariomichel.com -S smtp="mail.mariomichel.com:25" -a /home/mario/Config-Backupper/Devices/Firmware-Versions/Fortinet-Firmware-Versions.txt -a /home/mario/Config-Backupper/Devices/Firmware-Versions/Fortinet-Firmware-Count.txt 1108mario@gmail.com```

and get every month at 9:00am a mail* with two attatments with statistics of Fortinet Firmware installed on the FortiGates. See below...

<details>
<summary>Fortinet-Firmware-Versions.txt</summary>
<br>
...
  
abc-so-fw-01 FG100E-5.04-FW-build1117-170207
  
rmb-st-fw-01 FGT61E-5.04-FW-build1117-170207

stt-bf-fw-01 FWF60E-6.0.4-FW-build0231-190107

gfg-bu-fw-01 FG100E-6.0.2-FW-build0163-180725

umg-gu-fw-01 FWF60E-6.0.4-FW-build0231-190107

...
</details>

<details>
<summary>Fortinet-Firmware-Count.txt</summary>
<br>
...
  
1 x FortiOS 4.00
  
14 x FortiOS 6.0.3

26 x FortiOS 6.0.4

9 x FortiOS 6.0.5

3 x FortiOS 6.0.6

1 x FortiOS 6.2.0

8 x FortiOS 6.2.1

...
</details>

*You can also display them on a website see for this **Hook stats to a website**

#### Hook stats to a website

In ./Modules/FirmwareCheck/Fortinet/FirmwareChecker.sh under the section **Display on a website** you can enable a command that will create you html files by uncommenting the line (removing the #). All infos in the module.

# How to configure

## Server side

In ./Devices/\<VENDOR>/\<DEVICE-MODEL>.txt you need to enter line by line all IP addresses.

### Syntax
\<IP> --> \<HOSTNAME> ### \<COMMENT>

#### For example

```192.168.1.1 --> mm-vie-fw-01 ### Firewall is very secure```*

Use a # in front of a line to uncomment a line (This will get ignored from the backup script).

```#10.0.0.1 --> mm-vie-fw-01-old ### Old Firewall```*

*Hostname (will be obtained from the backup file directly) and a comment are optional.

## Enabling the Main Modules

In ./Main-Launcher.sh are modules under the section **Backup Modules** that need to enabled by uncommenting the line (removing the #). Check with ```./Modules/Setup/ModuleChecker.sh``` if all needed modules has been enabled correctly.

#### For example

```
...
### Backup Modules ###
./Modules/Backup/Fortinet/Fortinet.sh &>> ./Log/Fortinet/log$date.txt             <-- Module enabled
./Modules/Backup/Cisco/Cisco.sh &>> ./Log/Cisco/log$date.txt                      <-- Module enabled
# ./Modules/Backup/DELL/DELL.sh &>> ./Log/DELL/log$date.txt                       <-- Module disabled
# ./Modules/Backup/HP/HP.sh &>> ./Log/HP/log$date.txt                             <-- Module disabled
...
```

## Enabling the Submodules

./Modules/Backup/\<VENDOR>/\<DEVICE-MODEL>.sh are sub modules and under the section **Sub Backup Modules**  you need to enable the sub backup moudles by uncommenting the line (removing the #). Check with ```./Modules/Setup/ModuleChecker.sh``` if all needed modules has been enabled correctly.
  
#### For example
```
...
### Backup Modules ###
./Modules/Backup/Cisco/sgX00.sh            <-- Module enabled
# ./Modules/Backup/Cisco/n3XXX.sh          <-- Module disabled
...
```

### Submodules (Login credentials)

In each* submodule you will find a section on the top that looks like that. in this section you need to define the credencals 

```
...
user="<VENDOR>"
passwd="XXXXXXPASSWORDXXXXXX"
...
```

*Fortigates are working with the SSH key. No password required.

## Client side (Network device)*

Create or use an existing read only profile for a user named "backup" (All in small letters, all togther, no spaces) on the device. This user should get only read rights for highest security. Also add the ./SSH-Keys/Backup-SSH-Key.pub to the user that this key pair can be used to login. See table **Use SSH-Key for Authenictaion** how to do that for each vendor.

### Use SSH-Key for Authenictaion
| Vendor        | Link           | Info  |
| :------------- |:-------------| :-----|
| Fortinet      |[Authenticate a CLI administrator using SSH keys](https://kb.fortinet.com/kb/documentLink.do?externalID=11985)| Also see [Technical Note: How to download a FortiGate configuration file and upload firmware file using secure file copy (SCP)](https://kb.fortinet.com/kb/documentLink.do?externalID=FD43754) |
| DELL       |       | Note : [SSH Key Auth on Dell PowerConnect Switches](https://eengstrom.github.io/musings/ssh-key-auth-powerconnect)  |
| Cisco      |       |   |
| HP         | [Configure the switch for SSH authentication](http://h22208.www2.hpe.com/eginfolib/networking/docs/switches/YA-YB/15-18/5998-8153_yayb_2530_asg/content/ch08s06.html#s_5Configuring_the_switch_for_SSH_authentication)   | Note : See step **Option B: Configuring the switch for client Public-Key SSH authentication** in order to use the client, so in our case the server sided SSH key. |

### *Or use the ./Modules/Setup/\<VENDOR>/AutoSetup.sh to setup the client side

Note : Run as sudo !!!


# How to test 

You can test the script (Recommended) befor you run it automaticaly to get the config file with ```scp -P <PORT> -vvv -i ./SSH-Keys/Backup-SSH-Key backup@<IP>:<CONFIGFILE>  ./TestConfigFile```. If that worked and the config file is now stored as **TestConfigFile**. You can delete the **TestConfgiFile** and run the script and see what happens.

### Remote name of the config file

| Name     | File  |  Note | 
| :------------- |:------------- | :----- |
| Fortinet| sys_config or fgt-config | [Backup over SCP](https://forum.fortinet.com/tm.aspx?m=114055) |
| 2 |   |   |
| 3 |   |   |

# About 

The script uses a (YOU-CHOOSE-IT) bit long SSH Key for authentication. That key must be added to all devices at the user backup in order for the script to get the configs. In the directory ./Log will be all output generated by the script for each day and each vendor.
  
  # Limitaions
  | LimitNr        | Limitation           | Reason  | Will be fixed | 
| :-------------: |:------------- | :----- | :-----: |
| 1  |  If you try to run the scrip more often than once a day the logs of the secound run will also be in the same log file  | Logging has not been designed for this | No |
| 2  | If you try to create a bigger SSH-Key than 16384 bit it will not work due to limitations  | There is a limit for the max key lenght in ssh-keygen if the key bits exceeds the of maximum 16384 | Not dependent on the script | 
| 3 | If you try to run the scrip/module more often than once a minute the configs will get overwritten | Backup has not been designed for this. Timestamp do not have seconds See in any ./Modules/Backup/\<VENDOR>/\<DEVICE-MODEL>.sh ```date=$(date +"%H-%M_%d-%m-%Y") ``` will create file like **mm-vie-fw-01-HH-MM_DD-MM-YYYY.conf** | No |
| 4 | If you run the script more often than once in 120 minutes the output of ./Modules/Archive/ArchiveStats.sh **Current Configs in Archive** will not be correct | Due to a setting in the module. Change ```-mmin -120``` to a lower value e.g ```-mmin -30```. This can cause problems getting all configs if they are oder than the defined value (Will show say less **Current Configs in Archive** than realy backuped.)| More likely yes |
| 5 | If the backup process takes more than 120 minutes the output of ./Modules/Archive/ArchiveStats.sh will not be correct | Due to settings in the modules. Change ```-mmin -120``` to a higher value e.g ```-mmin -360``` to fix in ./Modules/Archive/ArchiveStats.sh **Total lines operating devices** and **Average lines in conifig file** in ./Modules/Archive/ArchiveStats.sh will **Current Configs in Archive** get fixed and will be displayed correctly | No (Can be fixed manually) |

# Facing Problems

### General :

| Problem     | Solution  |  Description | 
| :------------- |:------------- | :----- |
| ssh: connect to host \<IP-ADDRESS> port 22: Connection timed out | Check if port 22 used for SSH  | If SSH do not use the port 22 (Default) you need to place the host inside the special module of the certain vendor (Problem caused by scp because it automaticaly uses port 22 if no other port is defined) |
| More **Directorys in Archive** than **Lines in Host file** (Can be seen in ./Log/Backup/log\<DATE>.txt)| Just leave the folders as it is or move all to the operating node | This could be caused due to a switch over form the device e.g. fw-01 to fw-02 (Cluster) |
| Less **Directorys in Archive** than **Lines in Host file** (Can be seen in ./Log/Backup/log\<DATE>.txt)| Try the backup again | You didn't got all configs listed in the host files check the ./Log/Failed/Failed-$date.txt for more infos |



### Fortinet :

| Problem     | Solution  |  Description | 
| :------------- |:------------- | :----- |
| Sink: 501-Permission Denied 501-Permission Denied | Check if enabled SCP on the Fortinet Device | The script can connect but has problems with the rights to copy the config file. If you don't enable SCP you can run into this problem. |
| 2 |   |   |
| 3 |   |   |


### Cisco :

| Problem     | Solution  |  Description | 
| :------------- |:------------- | :----- |
| [i]: (sgX00.sh) Output was trash, try again in 15 minutes | Check the credentials and also if the switch uses http or https | Wrong credentials, http or https connection method can be the reason. This can be changed in ./Modules/Backup/Cisco/sgX00.sh |
| 2 |   |   |
| 3 |   |   |



  
