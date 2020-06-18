#!/bin/bash

function message() {
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m $1 \e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"

}

message "Adding $USER to sudoers"
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
message "Making swap"
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 700 /swapfile
sudo mkswap /swapfile
echo -e "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon /swapfile
message "Upgrading packages"
sudo pacman-mirrors -c Russia
sudo pacman -Syyu --noconfirm
message "Installing packages from pacman"
sudo pacman -S base-devel yay php nodejs npm yarn postgresql go vim code plank ntp --noconfirm
message "Setting time-zone"
sudo timedatectl set-timezone Europe/Moscow
sudo timedatectl set-ntp true
message "Installing packages from yay"
yay -S google-chrome rbenv ruby-build composer deployer sublime-text-3-imfix dbeaver plank-theme-arc flameshot --noconfirm
RUBY_VERSION=$(rbenv install -l 2>/dev/null | head -1)
message "Installing ruby-$RUBY_VERSION"
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install $RUBY_VERSION
rbenv local $RUBY_VERSION
gem install bundler
message "Configuring keyboard lang and panel label"
cp -rv ./dconf ~/.config/
rm ~/.config/plank/dock1/launchers/*
cp -rv ./plank ~/.config/
cp -rv ./plank.desktop ~/.config/autostart/plank.desktop
cp -v ./xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp -v ./xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
cp -v ./xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp -v ./keyboard-layout.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp -v ./xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
message "Rebooting system ..."
sleep 3
sudo reboot
