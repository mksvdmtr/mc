#!/bin/sh

sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 700 /swapfile
sudo mkswap /swapfile
sudo echo "/swapfile none swap defaults 0 0" >> /etc/fstab
cp ./keyboard-layout.xml .config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp ./xfce4-panel.xml .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

sudo pacman-mirrors -c Russia
sudo pacman -Syyu --noconfirm
sudo pacman -S base-devel yay php nodejs npm yarn postgresql pgadmin4 go --noconfirm
yay -S google-chrome rbenv composer deployer sublime-text-3-imfix --noconfirm
