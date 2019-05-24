#!/bin/bash
# run as root
# Grabs top 5 arch mirrors from web and puts them in /etc/pacman.d/mirrorlist

pacman -Q pacman-contrib &>/dev/null || sudo pacman -Syq pacman-contrib
echo 'Creating backup of old mirrorlist...'
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo 'Pulling current mirrorlist from archlinux.org/mirrorlist...'
curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6&uuse_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^## U/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacman -Syy && echo 'pacman mirrorlist updated!' && cat /etc/pacman.d/mirrorlist
