#!/bin/bash

function message() {
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
	echo -e "\e[92m\e[1m $1 \e[0m"
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
}

function ruby_env() {
	message "Installing ROR env"
	sudo pacman -S postgresql qt5-webkit --noconfirm
	sudo su - postgres -c "initdb --locale ru_RU.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
	sudo systemctl enable postgresql && sudo systemctl start postgresql
	yay -S rbenv ruby-build --noconfirm
	RUBY_VERSION=$(rbenv install -l 2>/dev/null | head -1)
	message "Installing ruby-$RUBY_VERSION"
	echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
	source $HOME/.bashrc
	eval "$(rbenv init -)"
	rbenv install $RUBY_VERSION
	rbenv local $RUBY_VERSION
	gem install bundler
}

function php_env() {
	message "Installing PHP env"
	sudo pacman -S mariadb apache php-apache postgresql-libs composer --noconfirm
	sudo systemctl enable httpd && sudo systemctl start httpd
	sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl enable mariadb && sudo systemctl start mariadb
	yay -S deployer phpbrew --noconfirm
	echo "extension=bz2.so" | sudo tee -a /etc/php/php.ini
        phpbrew init
	echo "[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc" >> $HOME/.bashrc
        source $HOME/.phpbrew/bashrc 
	phpbrew install -j $(nproc) 7.4.7 +default+dbs
	phpbrew switch 7.4.7
	phpbrew ext install imagick 3.4.4
}

paths=(
	"./dconf $HOME/.config/" 
	"./plank $HOME/.config/"
	"./plank.desktop $HOME/.config/autostart/plank.desktop"
	"./xfwm4.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
	"./xfce4-keyboard-shortcuts.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
	"./xfce4-desktop.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
	"./keyboard-layout.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml"
	"./xfce4-panel.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
)

message "What environment to install?
	1: ruby
	2: php"
read CHOICE

case $CHOICE in
	1) DEV_ENV=ruby
		;;
	2) DEV_ENV=php
		;;
	*) echo "You have not chosen anything"
esac

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
sudo pacman -S base-devel yay nodejs npm yarn go vim code plank ntp --noconfirm
message "Setting time-zone"
sudo timedatectl set-timezone Europe/Moscow
sudo timedatectl set-ntp true
message "Installing packages from yay"
yay -S google-chrome dbeaver postman plank-theme-arc flameshot --noconfirm

case $DEV_ENV in
    ruby)
	ruby_env
      ;;
    php)
	php_env
      ;;
esac

message "Configuring keyboard lang and panel label"
rm $HOME/.config/plank/dock1/launchers/*

if [ "$XDG_CURRENT_DESKTOP" == "XFCE" ]; then
	for p in "${paths[@]}"; do
		cp -rv $p
	done
fi

message "Rebooting system ..."
sleep 3
sudo reboot
