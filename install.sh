#!/bin/bash

# This script will install the z_tramming macro and configuration files into your klipper configuration.
set -euo pipefail

function install() {
	origin=https://github.com/Jomik/klipper-z-tramming.git
	dir=$HOME/z_tramming

	git clone $origin $dir

	echo "Linking macros to into config"
	ln -s $dir/macros $HOME/printer_data/config/z_tramming >/dev/null

	echo "Copying z_tramming_settings.cfg to config directory"
	cp $dir/macros/z_tramming_settings.cfg $HOME/printer_data/config/z_tramming_settings.cfg
}

function backup_file() {
	local file=$1
	local stamp=$(date +"%Y%m%d_%H%M%S")
	local file_bak="${file}.${stamp}.bak"
	echo "Backing up $file to $file_bak"
	cp "$file" "$file_bak"
}

function include_in_config() {
	backup_file "$HOME/printer_data/config/printer.cfg"
	echo "Including macro and configuration at the top of printer.cfg"
	ed -s $HOME/printer_data/config/printer.cfg <<EOF
0 i
# Include Z_Tramming macro
# $origin
[include z_tramming_settings.cfg]
[include ./z_tramming/z_tramming.cfg]
.
w
EOF
}

function add_to_moonraker() {
	backup_file "$HOME/printer_data/config/moonraker.conf"
	echo "Adding z_tramming to moonraker.conf"
	cat >>$HOME/printer_data/config/moonraker.conf <<EOF
[update_manager Z_Tramming]
type: git_repo
channel: dev
path: ~/z_tramming
origin: $origin
managed_services: klipper
primary_branch: main
EOF
}

echo "Do you wish to install Z Tramming?"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		install
		break
		;;
	No) exit ;;
	esac
done

echo "Do you wish to automatically include in printer.cfg?"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		include_in_config
		break
		;;
	No)
		echo -e "Please include the following lines in your printer.cfg\n[include z_tramming_settings.cfg]\n[include ./z_tramming/z_tramming.cfg]"
		break
		;;
	esac
done

echo "Do you wish to automatically add to moonraker?"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		add_to_moonraker
		break
		;;
	No) break ;;
	esac
done

echo "Done! Please edit z_tramming_settings.cfg to match your printer."
