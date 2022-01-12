#!/bin/bash

VERSION=0.1

if [[ $EUID -ne 0 ]]; then
  echo "The installation must be run as root."
  echo "Please enter your password:"
  sudo "$0" "sudo sh -c \"$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)\""
  exit $?
fi

echo "
  .d888      8888888888 8888888b. 8888888 .d8888b.  8888888888 888b    888          888b.
 d88P\"       888        888   Y88b  888  d88P  Y88b 888        8888b   888           \"Y88b
 888         888        888    888  888  888    888 888        88888b  888             888
.888         8888888    888   d88P  888  888        8888888    888Y88b 888             888.
888(         888        8888888P\"   888  888  88888 888        888 Y88b888             )888
\"888         888        888         888  888    888 888        888  Y88888             888\"
 888         888        888         888  Y88b  d88P 888        888   Y8888 d8b         888
 Y88b.       8888888888 888       8888888 \"Y8888P88 8888888888 888    Y888 Y8P       .d88P
  \"Y888                                                                             888P\"

Developed by Raphael MERCIE - EPITECH Toulouse 2026

------------ Starting installation ------------
"
if [ -d "/usr/local/lib/epitech-gen" ]; then
  echo "Remove old version..."
  sudo rm -r "/usr/local/lib/epitech-gen"
fi
cd "/tmp/"
echo "Cloning Epigen git repository..."
git clone "https://github.com/raphaelMrci/Epigen.git"
echo "Repo cloned."
echo "Copying files..."
sudo cp -r "Epigen" /usr/local/lib/Epigen
sudo cp "Epigen/epigen" /usr/local/bin/epigen
echo "Files copied."
echo "Removing tmp files..."
rm -r /tmp/Epigen
sudo rm -f /usr/local/lib/Epigen/epigen
echo "Giving perms..."
sudo chmod -R 777 /usr/local/lib/Epigen
sudo chmod 777 /usr/local/bin/epigen
echo "Permissions given"
echo "------------ Installation finished ------------"
echo "
Epigen installed successfully !
Thanks for installing Epigen. If you want more details to understand how to use Epigen, use the "-h" option.

Developed by raphael_mrci - Epitech Toulouse 2026
https://github.com/raphaelMrci

XoXo"
