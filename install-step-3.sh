#! /usr/bin/bash

# 3. Teil des Installations-Scriptes
# siehe Anleitung: https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger

echo "Dieses Script wird per chroot auf einem System-Sklett aufgerufen und konfiguriert das System von innen heraus. Falls dem nicht so ist: Strg+C !"

echo "Sind wir wirklich im chroot? Folgende Dateien befinden sich im aktuellen Ordner:"
ls


echo "root- & hans-Password setzen:"
echo "Bitte gewünschtes Passwort eingeben"
read passwd_choice
echo $passwd_choice | passwd root -s


echo "Hostname setzen..."
echo "Bitte gewünschten Hostnamen eingeben!"
read hostname
echo "$hostname" > /etc/hostname


echo "(local)hosts einrichten..."
echo -e "#<ip-address>	<hostname.domain.org>	<hostname>\n127.0.0.1	localhost.localdomain	localhost\n::1		localhost.localdomain	localhost" > /etc/hosts


echo "Sprache einstellen..."
echo LANG=de_DE.UTF-8 > /etc/locale.conf


echo "Ort einstellen..."
echo -e "de_DE.UTF-8 UTF-8\nde_DE ISO-8859-1\nde_DE@euro ISO-8859-15\nen_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen


echo "Zeitzone festlegen (symbolischer Link)..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime


echo "Tastaturbelegung & Schriftart der Konsole setzen..."
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf


echo "GRUB + GPUbase_driver + Tools installieren (es gibt Alternativen!); os-prober sorgt dafür, dass andere BS automatisch eingerichtet werden..."
# Mithilfe folgenden Befehls schonmal weitere wichtige Pakete installieren:
# Microcode statt "intel-ucode" bei AMD: "amd-ucode"
# Für WLAN-Verbindung zusätzlich "iwd"
pacman -S os-prober grub efibootmgr posix cups cups-pdf xf86-video-vesa --noconfirm
#-----------------------------------------------------------------------------------> Fehler: /proc muss gemounted sein!

echo "Sind wir wirklich im chroot? Folgendes ist die Antwort des ls-Befehls (-> welche sh-Dateien sind vorhanden?):"
ls
read userinput


echo "NetworkManager aktivieren"
systemctl enable NetworkManager.service


echo "CUPS aktivieren"
systemctl enable cups.service


echo "NUM beim Start automatisch aktivieren"
echo -e "#!/bin/bash\n\nfor tty in /dev/tty{1..6}\ndo\n    /usr/bin/setleds -D +num < "$tty";\ndone\n" > /usr/local/bin/numlock
chmod 111 /usr/local/bin/numlock
echo -e "[Unit]\nDescription=numlock\n\n[Service]\nExecStart=/usr/local/bin/numlock\nStandardInput=tty\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/numlock.service
systemctl enable numlock.service


echo "DisplayManager + DesktopEnvironment installieren..."
pacman -S xfce4 xfce4-goodies xorg-xdm xorg-server --noconfirm


echo "Initramfs erneut erzeugen, z.B. falls LVM eingerichtet wird, wie ist das bei Microcode?, /etc/kminitcpio.conf prüfen!"
mkinitcpio -p linux


echo "UEFI-Einträge einrichten (für BIOS siehe https://wiki.archlinux.de/title/Grub#Installation)..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="ARSCH - Mein Gans persönlicher GRUB-Bootloader"
grub-mkconfig -o /boot/grub/grub.cfg


echo "XDisplayManager aktivieren"
systemctl enable xdm.service
mkdir /home/root
echo "startxfce4" > /home/root/.xsession
chmod 777 /home/root/.xsession


echo "Sind wir wirklich im chroot? Folgende Dateien befinden sich im aktuellen Ordner:"
ls


echo "Hans anlegen"
echo "hans:x:501:100:Nutzer:/home/hans:/bin/bash" >> /etc/passwd
echo "hans::::::::" >> /etc/shadow
mkdir /home/hans
cp -r /etc/skel/* /home/hans
chown -R hans:hans /home/hans
echo $passwd_choice | passwd hans -s


echo "Schritt 3 is about to be verlassen... Sind wir wirklich im chroot? Folgende Dateien befinden sich im aktuellen Ordner:"
ls

exit 0
