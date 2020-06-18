#!/bin/bash

function message() {
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
	echo -e "\e[92m\e[1m $1 \e[0m"
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
}

function ruby_env() {
	message "Ruby env"
	yay -S rbenv ruby-build --noconfirm
	RUBY_VERSION=$(rbenv install -l 2>/dev/null | head -1)
	message "Installing ruby-$RUBY_VERSION"
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	source ~/.bashrc
	rbenv install $RUBY_VERSION
	rbenv local $RUBY_VERSION
	gem install bundler
}

function php_env() {
	message "PHP env"
	sudo pacman -S oniguruma tidy libzip --noconfirm
	yay -S composer deployer --noconfirm
	curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
	echo '
	export PHPENV_ROOT="/home/rsu/.phpenv"
	if [ -d "${PHPENV_ROOT}" ]; then
		  export PATH="${PHPENV_ROOT}/bin:${PATH}"
		    eval "$(phpenv init -)"
	fi' >> ~/.bash_profile

	export PHPENV_ROOT="/home/rsu/.phpenv"
	export PATH="${PHPENV_ROOT}/bin:${PATH}"
	eval "$(phpenv init -)"
	phpenv install 7.4.7
}

function php_brew() {
	yay -S phpbrew --noconfirm
	echo "extension=bz2.so" | sudo tee -a /etc/php/php.ini
        phpbrew init
	phpbrew install 7.4	
}

paths=(
	"./dconf ~/.config/" 
	"./plank ~/.config/"
	"./plank.desktop ~/.config/autostart/plank.desktop"
	"./xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
	"./xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
	"./xfce4-desktop.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
	"./keyboard-layout.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml"
	"./xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
)

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
sudo pacman -S base-devel yay nodejs npm yarn postgresql go vim code plank ntp --noconfirm
message "Setting time-zone"
sudo timedatectl set-timezone Europe/Moscow
sudo timedatectl set-ntp true
message "Installing packages from yay"
yay -S google-chrome sublime-text-3-imfix dbeaver plank-theme-arc flameshot --noconfirm

# case


message "Configuring keyboard lang and panel label"
rm ~/.config/plank/dock1/launchers/*

for p in ${paths[@]}; do
	cp -rv $p
done

message "Rebooting system ..."
sleep 3
sudo reboot
