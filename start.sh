#! /usr/bin/bash

# 1. Teil des Installations-Scriptes
# siehe Anleitung: https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger


echo "Schritt 1.1 - Tastaturlayout auf Deutsch stellen: ##############################################################"

loadkeys de-latin1


echo "Schritt 1.2 - Festplatte partitionieren: #######################################################################"
echo "Neuinstallation von UEFI-System: (Für BIOS siehe fdisk! (https://wiki.archlinux.de/title/Gdisk))"
echo "|   Festplatte löschen:   fdisk -l   gdisk   DISK   Enter   o   y   Enter   |"
echo "|   EFI-Partition:   n   Enter   Enter   +512M   Enter   ef00   Enter   |"
echo "|   SWAP-Partition:   n   Enter   Enter    +4G   Enter   8200   Enter   |"
echo "|   root-Partition:   n   Enter   Enter   Enter   Enter   |"
echo "|   mit   p   die Partitionierung überprüfen! Es sollten 512MB-EFI + SWAP + Linux-Filesystem vorhanden sein   |"
echo "|   Partitionstabelle schreiben:   w   y   Enter   |"
echo ""
echo "Danach weiter mit   sh ./install-step-2.sh"

curl https://raw.githubusercontent.com/StrongBeginner0815/arch-install/main/install-step-2.sh > install-step-2.sh

exit 0
