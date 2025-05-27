#!/usr/bin/env bash

###################################################################
## AD Rejoin                                                     ##
##                                                               ##
## Autor: XXX                                                    ##
## Datum: XXX                                                    ##
##                                                               ##
## Inhalt: Vollständige Rejoin in die Domäne <DOMAIN>            ##
##                                                               ##
## Zentrale Ablage, Aufruf erfolgt Remote über "rejlin"          ##
###################################################################

#Shell-Verhalten definieren
set -eEuo pipefail
#Anzeige des grafischen Auswahlmenue
whiptail --backtitle "AD Rejoin" --title "" --yesno "Das System wird erneut in die AD aufgenommen. Fortfahren?" 10 58
if [ $? -ne 0 ]; then
  exit
fi
clear
sleep 1
echo
#Anzeigen des Hostname
echo Hostname ist:
echo $HOSTNAME
echo
sleep 1
echo Rejoin in die AD beginnt....
sleep 1
#Durchfuehren AD Rejoin
sudo rm /etc/krb5.keytab
sudo rm -rf /var/lib/sss/db/*
sudo rm -f /tmp/krb5*
sudo cp /etc/sssd/sssd.conf /etc/sssd/sssd.bak
sudo realm leave
echo Bitte <TIER-ACCOUNT> OHNE @<DOMAIN> eingeben
echo Accountpasswort des <TIER-ACCOUNT> wird im Anschluss abgefragt
echo
sleep 1
read -p "Bitte <TIER-ACCOUNT> eingeben (bspw. <TIER>MaxMustermann): " DomainAdmin
sudo realm join -U $DomainAdmin <DOMAIN>
sudo mv /etc/sssd/sssd.bak /etc/sssd/sssd.conf
sudo systemctl restart sssd
sudo systemctl status sssd
