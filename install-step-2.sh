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

echo "weiter?"
read userinput

echo "Schritt 2.3 - Basispakete installieren... ########################################################################"

pacstrap /mnt base base-devel linux linux-firmware nano intel-ucode networkmanager


echo "Schritt 2.4 - fstab (File System Table) Datei erzeugen auf Grundlage der aktuellen Einbindungen & folgend prüfen: #"

genfstab -U /mnt > /mnt/etc/fstab


echo "Download installation-script-step 3..."
curl https://raw.githubusercontent.com/StrongBeginner0815/arch-install/main/install-step-3.sh > /mnt/install-step-3.sh
chmod 777 /mnt/install-step-3.sh

echo "Schritt 3.1 - chroot (change root) & Aufruf des 3. Installationsscriptes: #########################################"
arch-chroot /mnt /mnt/install-step-3.sh

echo "3. Installationsscript wurde beendet. Folgende Dateien befinden sich im aktuellen Ordner:"
ls


echo "Gemountete Partitionen unmounten... Warte auf ein ENTER..."
read user_input

umount /mnt/boot
umount /mnt


echo "Schritt x.x - FERTIG! Das System neustarten... #####################################################################"
echo "############################################## Abbruch mit Strg. + C ###############################################"
echo "####################################################################################################################"

exit 0
