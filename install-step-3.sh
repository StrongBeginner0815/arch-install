#! /usr/bin/bash

# 3. Teil des Installations-Scriptes
# siehe Anleitung: https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger

echo "Dieses Script liegt im chroot und konfiguriert das System von innen heraus."
echo "Warte auf ENTER"
read waiting

echo "Hostname setzen..."
echo HOSTNAME > /etc/hostname

echo "Sprache einstellen..."
echo LANG=de_DE.UTF-8 > /etc/locale.conf

echo "Ort einstellen..."
echo -e "de_DE.UTF-8 UTF-8\nde_DE ISO-8859-1\nde_DE@euro ISO-8859-15\nen_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "Tastaturbelegung & Schriftart der Konsole setzen..."
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf

echo "Zeitzone festlegen (symbolischer Link)..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

echo "localhosts einrichten ÜBERSPRINGEN"
# echo -e "#<ip-address>	<hostname.domain.org>	<hostname>\n127.0.0.1	localhost.localdomain	localhost\n::1		localhost.localdomain	localhost" > /etc/hosts

echo "Initramfs erneut erzeugen, z.B. falls LVM eingerichtet wird, wie ist das bei Microcode?, /etc/kminitcpio.conf prüfen! ÜBERSPRINGEN"
# mkinitcpio -p linux

echo "root-Password setzen:"
echo "Bitte gewünschtes Passwort eingeben"
read passwd_choice
echo $passwd_choice | passwd root -s

echo "GRUB installieren (es gibt Alternativen!); os-prober sorgt dafür, dass andere BS automatisch eingerichtet werden..."
pacman -S grub efibootmgr os-prober --noconfirm

echo "UEFI-Einträge einrichten (für BIOS siehe https://wiki.archlinux.de/title/Grub#Installation)..."
echo $(grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="ARSCH - Mein Gans persönlicher GRUB-Bootloader")
echo $(grub-mkconfig -o /boot/grub/grub.cfg)

echo "Script inside chroot is ready. Drücke Enter!"
read wait_for_enter

exit 0