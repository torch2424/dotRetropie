#!/usr/bin/env bash
echo ""
echo "Switching default boot system to emulationstation and rebooting"
echo ""
sleep 5
cp /opt/retropie/configs/all/ES-Start.sh /opt/retropie/configs/all/autostart.sh
sudo reboot
#ps -fu `whoami` |grep attract |grep -v xinit |grep -v grep |grep -v xterm| awk '{print $2}' | xargs kill -9

