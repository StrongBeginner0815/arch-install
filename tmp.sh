echo "chroot (change root) in die Mount-Partition zum Anpassen fehlender Konfigurationen: ###############"
arch-chroot /mnt ls #./install-step-3.sh

echo "Aus der chroot-Umgebung austreten & gemountete Partitionen unmounten... Warte auf ein ENTER..."
read user_input

exit
umount /mnt/boot
umount /mnt

echo "FERTIG! Das System sollte jetzt mit dem Befehl   reboot   neugestartet werden."

exit 0
