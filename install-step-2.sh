#! /usr/bin/bash

# 2. Teil des Installations-Scriptes
# siehe Anleitung: https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger


echo "Schritt 2.1 - Partitionen formatieren: #########################################################################"

fdisk -l
echo "Bitte EFI-Partitions-Pfad eingeben, z.B.    /dev/nvme0n1p1   :"
read efi_partname
echo "Bitte SWAP-Partitions-Pfad eingeben, z.B.    /dev/nvme0n1p2   :"
read swap_partname
echo "Bitte ROOT-Partitions-Pfad eingeben, z.B.    /dev/nvme0n1p3   :"
read root_partname

echo "EFI-Partition with   mkfs.fat -F 32 -n BOOT $efi_partname   :"
echo $(mkfs.fat -F 32 -n BOOT $efi_partname)

echo "SWAP-Partition with   mkswap -L SWAP $swap_partname   :"
echo $(mkswap -L SWAP $swap_partname)

echo "root-Partition with   mkfs.ext4 -L ROOT $root_partname   :"
echo $(mkfs.ext4 -L ROOT $root_partname)


echo "Schritt 2.2 - Partitionen mounten & SWAP aktivieren...###########################################################"

echo $(mount -L ROOT /mnt)
echo $(mkdir /mnt/boot)
echo $(mount -L BOOT /mnt/boot)
echo $(swapon -L SWAP)


echo "Schritt 2.3 - Basispakete installieren... ########################################################################"

pacstrap /mnt base base-devel linux linux-firmware nano

echo "Schritt 2.4 - fstab (File System Table) Datei erzeugen auf Grundlage der aktuellen Einbindungen & folgend prüfen: #"

echo $(genfstab -U /mnt > /mnt/etc/fstab)
cat /mnt/etc/fstab
echo "--- Ist die fstab okay? [0/1]"

read fstab_okay
if [ $fstab_okay ]
	then
		echo "Alles klar! Weiter gehts..."
	else
		echo "fstab nicht okay?! Abbruch! Bitte Fehler beheben und dann weitermachen mit   sh ./arch-install-3.sh   ." && exit 1
fi

echo "Download installation-script-step 3..."
curl https://raw.githubusercontent.com/StrongBeginner0815/arch-install/main/install-step-3.sh > /mnt/install-step-3.sh
chmod 777 /mnt/install-step-3.sh

echo "Schritt 3.1 - chroot (change root) in die Mount-Partition zum Anpassen fehlender Konfigurationen: ###############"
arch-chroot /mnt ./install-step-3.sh

echo "Jetzt wird wieder Schritt 2 .sh ausgeführt. Folgendes ist die Antwort des ls-Befehls:"
ls

echo "Aus der chroot-Umgebung austreten & gemountete Partitionen unmounten... Warte auf ein ENTER..."
read user_input

exit
umount /mnt/boot
umount /mnt

echo "FERTIG! Das System sollte jetzt mit dem Befehl   reboot   neugestartet werden."

exit 0
