#!/bin/bash

# check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo -e "\e[1;31m [-] Please run as root \e[0m"
  exit
fi

# Update pacman.conf
#sudo cp /home/$USER/Documents/dotfiles/install/pacman.conf /etc/pacman.conf

# Install main packages
echo -e "\e[3;32m [*] Installing main packages...\e[0m"
echo
# removed: picom, qtile, gvim, rofi, alacritty, neofetch, ytfzf, filezilla, kitty, tmux, flameshot, helix, network-manager-applet, gping, lazygit, ghostscript, strawberry, dillo, falkon, hexchat
sudo pacman -Syu github-cli npm nodejs fish wget rust fzf physlock python python-pip go dunst unzip mpv zip pcmanfm brightnessctl neovim tk bluez bluez-utils blueman dmenu
echo -e "\e[1;32m [ \uf00c ] Done. \e[0m"

# INSTALLING ST TERMINAL
echo -e "\e[3;32m [*] Installing ST...\e[0m"
mkdir -p ~/.local/src
git clone https://github.com/Rooyca/st.git ~/.local/src/st --depth=1
cd ~/.local/src/st
sudo make install
echo -e "\e[1;32m [ \uf00c ] Done. \e[0m"

# Services
# Bluetooth
#sudo sed -i '/^#AutoEnable/s/^#//' /etc/bluetooth/main.conf
#sudo systemctl enable --now bluetooth.service

# SET FISH AS DEFAULT SHELL
#echo -e "\e[3;32m [*] Setting zsh as default shell...\e[0m"
#chsh -s $(which fish)
#echo -e "\e[1;32m [ \uf00c ] Done. \e[0m"

# COMPILE DWM-SETSTATUS 
#gcc /home/$USER/Documents/dotfiles/.scripts/dwm-setstatus.c -lX11 -o dwm-setstatus
#sudo mv dwm-setstatus /usr/local/bin

# INSTALLING DWM
echo "\e[3;32m [*] Installing dwm... \e[0m"
git clone https://git.suckless.org/dwm ~/.local/src/dwm --depth=1
cd ~/.local/src/dwm
cp ~/Documents/dotnix/config/dwm/config.def.h .
mkdir patches && cd patches

wget https://dwm.suckless.org/patches/movestack/dwm-movestack-20211115-a786211.diff
wget https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff
wget https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff
wget https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.4.diff
wget https://dwm.suckless.org/patches/focusmonmouse/dwm-focusmonmouse-6.2.diff
wget https://dwm.suckless.org/patches/cursorwarp/dwm-cursorwarp-6.3.diff

cd ..

patch -p1 < patch/dwm-movestack-20211115-a786211.diff
patch -p1 < patch/dwm-cursorwarp-6.3.diff  
patch -p1 < patch/dwm-focusmonmouse-6.2.diff  
patch -p1 < patch/dwm-hide_vacant_tags-6.4.diff  
patch -p1 < patch/dwm-noborderfloatingfix-6.2.diff  
patch -p1 < patch/dwm-systray-20230922-9f88553.diff
patch -p1 < patch/dwm-movestack-20211115-a786211.diff

sudo make install

# REBOOT
echo "\e[3;32m === PLEASE REBOOT YOUR SYSTEM === \e[0m"