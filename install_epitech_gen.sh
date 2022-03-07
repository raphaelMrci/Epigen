#!/bin/bash

VERSION=0.3.3

if [[ $EUID -ne 0 ]]; then
    echo "The installation must be run as root."
    echo "Please enter your password:"
    sudo "$0" "sudo bash -c \"$(curl -fsSL https://raw.githubusercontent.com/raphaelMrci/Epigen/main/install_epitech_gen.sh)\""
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

# Cleaning old version #
if [ -d "/usr/local/share/epitech-gen" ]; then
    echo "Remove old version..."
    sudo rm -r "/usr/local/share/epitech-gen"
fi
if [ -d "/usr/local/share/Epigen" ]; then
    echo "Remove old version..."
    sudo rm -r "/usr/local/share/Epigen"
fi
if [ -f "/usr/local/bin/epitech-gen" ]; then
    echo "Remove launcher..."
    sudo rm -f "/usr/local/bin/epitech-gen"
fi
if [ -f "/usr/local/bin/epigen" ]; then
    echo "Remove launcher..."
    sudo rm -f "/usr/local/bin/epigen"
fi

if [ -d "/tmp/Epigen" ]; then
    echo "Remove tmp"
    sudo rm -r "/tmp/Epigen"
fi
cd "/tmp/"
echo "Cloning Epigen git repository..."
git clone "https://github.com/raphaelMrci/Epigen.git"
echo "Repo cloned."
echo "Copying files..."
sudo cp -r "Epigen" /usr/local/share/
sudo ln -s "/usr/local/share/Epigen/epitech_gen.sh" /usr/local/bin/epigen
echo "Files copied."
echo "Removing tmp files..."
sudo rm -r /tmp/Epigen
echo "Giving perms..."
echo "Remove useless files..."
sudo rm -R /usr/local/share/Epigen/.git
sudo rm -R /usr/local/share/Epigen/epigen.bat
sudo rm -R /usr/local/share/Epigen/assets
sudo rm -R /usr/local/share/Epigen/README.md
sudo chmod -R a=rx /usr/local/share/Epigen
echo "Permissions given"
echo "------------ Installation finished ------------"
echo "
Epigen installed successfully !
Thanks for installing Epigen. If you want more details to understand how to use Epigen, write \"epigen -h\".

Developed by raphael_mrci - Epitech Toulouse 2026
https://github.com/raphaelMrci

XoXo"
