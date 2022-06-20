#!/bin/bash

# make var of conf files to enable custom locations

conf_path=$(pwd)
curr_time=$(date +'%m-%d-%Y_%Hh%Mm')


function backup () {
######################################################
# make backup of current conf state for easy restore #
######################################################


if [[ ! -d $conf_path/.BAK ]]; then
	mkdir $conf_path/.BAK
fi

if [[ ! -d $conf_path/.BAK/$curr_time ]]; then
	mkdir  $conf_path/.BAK/$curr_time

	cp ~/.zshrc $conf_path/.BAK/$curr_time/ 
	cp ~/.bash_aliases $conf_path/.BAK/$curr_time/
	cp ~/.p10k.zsh $conf_path/.BAK/$curr_time/
	cp ~/.vimrc $conf_path/.BAK/$curr_time/

	echo "Backup created in $conf_path/.BAK/$curr_time/\n"
	
else 
	echo "Could't create Backup, please try again in 1 minute."
	exit
fi
}

function install () {
######################################################
# make backup of current conf state, clone p10k and  #
#  populate the config files                         #
######################################################


if [[ ! -d ~/powerlevel10k ]]
then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo "cloned p10k files to ~/powerlevel10k\n"
else
	echo "p10k files already exists\n"
fi

cp $conf_path/zshrc ~/.zshrc
cp $conf_path/bash_aliases ~/.bash_aliases
cp $conf_path/p10k.zsh ~/.p10k.zsh
cp $conf_path/vimrc ~/.vimrc

echo "Finished populating config files from $conf_path to home dir."

}

function help_option (){
#####################################################
# Print out possible options on -h option           #
#####################################################

echo "help page"

}

function restore_promt () {
###############################
# Restore from latest backup  #
###############################

read -p "Do you really want to continiue with the restore from backup? (y/n) " choice
case "$choice" in 
	y|Y ) echo "Continuing with the restore process"; restore_do;;
	n|N ) echo "Aborting the restore process"; exit 0;;
  	* ) echo "The answer was invalid. Please try again"; restore_promt ;;
		
esac
}

function restore_do () {
latest=$(ls -td $conf_path/.BAK/* | head -1)
cp $latest/.zshrc ~/.zshrc
cp $latest/.bash_aliases ~/.bash_aliases
cp $latest/.p10k.zsh ~/.p10k.zsh
cp $latest/.vimrc ~/.vimrc

echo "Restore complete"
exit 0
}

###############################################
# get options and run the specified functions #
###############################################

while getopts ":iborh" option; do
   case $option in
	i)	backup; install;;
	b)	backup;;
	o)	install;;
	r)	echo "Restore not implemented yet"
	h)	echo "help not implemented yet"
  	\?)	echo "Error: Ivalid option, try -h for a list of options";;  
   esac
done

