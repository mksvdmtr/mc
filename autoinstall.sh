#!/bin/sh
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Add $USER to sudoers\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Make swap\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 700 /swapfile
sudo mkswap /swapfile
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
printf "%$(tput cols)s\n"|sed "s/ /#/g"
sudo swapon /swapfile
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Upgrade packages\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
sudo pacman-mirrors -c Russia
sudo pacman -Syyu --noconfirm
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Install packages from pacman\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
sudo pacman -S base-devel yay php nodejs npm yarn postgresql go vim atom plank --noconfirm
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Install packages from yay\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
yay -S google-chrome rbenv composer deployer sublime-text-3-imfix dbeaver plank-theme-arc --noconfirm
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Configure keyboard lang and panel label\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
cp -rv ./dconf ~/.config/
cp -rv ./plank ~/.config/
cp -rv ./plank.desktop ~/.config/autostart/plank.desktop
cp -v ./xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp -v ./xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp -v ./keyboard-layout.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp -v ./xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
printf "%$(tput cols)s\n"|sed "s/ /#/g"
echo -e "\e[92m\e[1m Rebooting system ...\e[0m"
printf "%$(tput cols)s\n"|sed "s/ /#/g"
sleep 3
echo -e "\e[92m\e[1m Bye Bye :)\e[0m"
sleep 1
sudo reboot

