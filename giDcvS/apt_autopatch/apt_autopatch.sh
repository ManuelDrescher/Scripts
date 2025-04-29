#!/usr/bin/env bash

###################################################################
## apt autopatch                                                 ##
##                                                               ##
## Autor: XXXX                                                   ##
## Datum: XXXX                                                   ##
##                                                               ##
## Inhalt: Automatisches Patchen mit anschl. Aufräumen           ##
## und Planung des Reboot                                        ##
##                                                               ##
## Zentrale Ablage, Aufruf erfolgt Remote über patch_me.sh       ##
###################################################################

#Shell-Verhalten definieren
set -eEuo pipefail
#Festlegen der verfuegbaren Farben
YW=$(echo "\033[33m")
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
CM='\xE2\x9C\x94\033'
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
#Anzeige des grafischen Auswahlmenue
whiptail --backtitle "Automatic Update" --title "" --yesno "Das System wird automatisch gepatched. Fortfahren?" 10 58
if [ $? -ne 0 ]; then
  exit
fi
clear
sleep 1
echo
#Anzeigen des Hostname
echo -e "${GN}Hostname ist:${CL}"
echo $HOSTNAME
echo
#Anzeigen des freien Speicherplatzes auf /
echo -e "${GN}Freier Speicherplatz auf /:${CL}"
df -h / | awk '{print $4}'
echo
sleep 1
#Hinweistext
echo -e "${RD}ACHTUNG: Sollten im Rahmen des Updates Nachfragen erfolgen, ob bereits bestehende Konfigurations-Dateien"
echo -e "${RD}beibehalten oder ueberschrieben werden sollen, so sind diese BEIZUBEHALTEN!"
echo
read -p "Mit Enter akzeptieren...."
echo
sleep 1
#Paketliste aktualisieren
echo -e "${BL}--- Update Paketliste ---${CL}"
sleep 1
sudo apt update
echo
#System upgraden
echo -e "${YW}--- Upgrade System ---${CL}"
sleep 1
sudo apt -yq full-upgrade
echo
#System bereinigen
echo -e "${BL}--- Bereinige System ---${CL}"
sleep 1
sudo apt -yq --purge autoremove && sudo apt -yq autoclean
echo
sleep 1
#Pruefen ob ein Neustart erforderlich ist
#Wenn JA, dann Abfrage über Neustartverhalten Sofort, zu einem bestimmten Zeitpunkt oder gar nicht.
#Wenn NEIN, dann regulaeres Ende
if [ -f /var/run/reboot-required ]; then
  echo -e "${RD}Abgeschlosen - Neustart IST erforderlich.${CL}"
  sleep 1
  while true; do
  read -p "Soll das System jetzt (J) oder zu einem spaeteren (S) Zeitpunkt neugestartet werden? (J/S/A fuer abbrechen)? " antwort
  case "$antwort" in
    J)
      echo -e "${GN}System wird jetzt neugestartet....${CL}"
      sleep 2
      sudo shutdown -r now
      break 
      ;;
    S)
      read -p "Gewuenschte Neustartzeit im Format HH:MM eingeben: " zeit
      echo
      sudo shutdown -r $zeit
      echo -e "${GN}Der Neustart wird um $zeit ausgefuehrt.${CL}"
      echo
      echo "Beende...."
      sleep 2
      break
      ;;
    A)
      echo -e "${RD}Neustart abgebrochen.Beende...${CL}"
      sleep 1
      exit 0
      ;;
    *)
      echo -e "${RD}Ungueltige Eingabe. Bitte erneut versuchen.${CL}"
      ;;
  esac
done
else
  echo -e "${GN}Abgeschlossen - KEIN Neustart erforderlich.${CL}"
  sleep 1
fi
