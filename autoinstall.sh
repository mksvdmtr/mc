#!/bin/sh
echo -e "\e[92m\e[1m Add $USER to sudoers\e[0m"
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
echo -e "\e[92m\e[1m Make swap\e[0m"
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 700 /swapfile
sudo mkswap /swapfile
echo -e "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon /swapfile
echo -e "\e[92m\e[1m Upgrade packages\e[0m"
sudo pacman-mirrors -c Russia
sudo pacman -Syyu --noconfirm
echo -e "\e[92m\e[1m Install packages from pacman\e[0m"
sudo pacman -S base-devel yay php nodejs npm yarn postgresql pgadmin4 go vim atom --noconfirm
echo -e "\e[92m\e[1m Install packages from yay\e[0m"
yay -S google-chrome rbenv composer deployer sublime-text-3-imfix --noconfirm
echo -e "\e[92m\e[1m Configure keyboard lang and panel label\e[0m"
cp -v ./keyboard-layout.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp -v ./xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
clear
echo -e "\e[92m\e[1m Rebooting system\e[0m"
sleep 3
clear
echo -e "\e[92m\e[1m Bye Bye :)\e[0m"
sleep 1
sudo reboot

