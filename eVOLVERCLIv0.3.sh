#!/bin/bash
# ----------------------------------
# Define variables and move into directory
# ----------------------------------
#@echo off
#echo "What is the path to the dpu root folder (/path/to/folder/) ?" &&
#read dpupath && #reads user input as variable
#cd dpupath #move into the appropriate parent directory
cd ../dpu #move into the dpu directory (this assumes you copied the eVOLVERCLI into the repo alongside the other repositories)
echo "Set appropriate python call (python3):"  &&
read pythoncall && #user-defined pythoncall variable determines what string will be used for calling python
#pythoncall='python3' ****this with or without quotes has not worked****
#echo $pythoncall
#set to appropriate call for your system
#Python 3.6+ required (see ReadMe.md for further details)
 ---
# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " eVOLVER CLI v0.2"
	echo " Please Select One"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Log OD Calibration"
	echo "2. Log Temperature Calibration"
	echo "3. Run Experiment"
	echo "4. Open Electron Shell"
	echo "5. Graphing Utility"
	echo "0. Exit"
}
# read input from the keyboard and take a action
pause(){
   read -p "$*"
}
# fucntions invoked when user selects 0-5 from menu options.
read_options(){
	local choice
	read -p "Enter choice [0 - 5] " choice
	case $choice in
		1) LogODCal ;;
		2) LogTempCal ;;
		3) RunExperiment ;;
		4) OpenElectronShell ;;
		5) GraphingUtility ;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
#for standard values of variables across runs silence echo and read lines with #
#use variable = value lines
#optionally move these lines to the top
#examples in functions below where appropriate

#sucessively pulls up all three OD calibration fits by querying user for variables 
LogODCal(){
	echo "Log Calibration Selected"
	echo "What is the path to the calibration python script (./calibration/calibrate.py)?"  && 
	read directory && #variable for path to script
	#directory = /path_to/calibrate.py
	echo "The calibration python script will be called through $directory" &&
	echo "Please provide eVOLVER IP address (192.168.1.2):" &&
	echo "If unknown, press the eVOLVER name on the Raspberry Pi/Electron home screen" &&
	read evolverip && #variable needed to query eVOLVER Raspberry Pi server for calibration files
	#evolverip = 192.168.1.2
	echo "Thanks! Fetching calibrations" &&
	$pythoncall $directory -a $evolverip -g #calls in user-defined variables to get list of calibrations from eVOLVER
	echo "Enter  appropriate OD calibration name from the above list:" &&
	read evolvercalname && #variable for command
	echo "Calibration name is $evolvercalname" &&
	echo "What would you like to name the calibration file?" &&
	read filename && #variable for command
	echo "Thanks! Pulling up calibration graphs. When you exit, the terminal will query if you want to it log to the eVOLVER." &&
	echo "If you log it, it will be available for experiments under $filename." &&
	echo "Fetching OD calibration, three graphs for sigmoid-fit OD90, sigmoid-fit OD135, and the 3D fit" &&
	echo "After exiting the graphing interface, the terminal will query if you wish to log each to the eVOLVER." &&
	$pythoncall $directory -a $evolverip -n $evolvercalname -t sigmoid -f "$filename od90" -p od_90  #user-defined variables pulls the OD135 data and generates a sigmoid-fit calibration
	$pythoncall $directory -a $evolverip -n $evolvercalname -t sigmoid -f "$filename od135" + od135 -p od_135 #user-defined variables pulls the OD135 data and generates a sigmoid-fit calibration
	$pythoncall $directory -a $evolverip -n $evolvercalname -t 3d -f "$filename 3dfit" -p od_90,od_135 #user-defined variables pulls the OD90 and OD135 data and generates a 3D-fit calibration
	pause 'OD Calibration Fits Generated and Logged if Wanted, Press [Enter] key to return to menu...'
	show_menus
}
#pulls up temperature calibration by querying user for variables 
LogTempCal(){
	echo "Log Calibration Selected"
	echo "What is the path to the calibration python script (/calibration/calibrate.py)?"  && 
	read directory && #for calling the script
	#directory = /calibration/calibrate.py
	echo "The calibration python script will be called through $directory" &&
	echo "Please provide eVOLVER IP address (192.168.1.2):" &&
	echo "If unknown, press the eVOLVER name on the Raspberry Pi/Electron home screen" &&
	read evolverip && #needed to query eVOLVER Raspberry Pi for calibration files
	#evolverip = 192.168.1.2
	echo "Thanks! Fetching calibrations" &&
	$pythoncall $directory -a $evolverip -g && #calls in user-defined variables to get list of calibrations from eVOLVER
	echo "Enter  appropriate OD calibration name from the above list:" &&
	read evolvercalname && #variable for command
	echo "Calibration name is $evolvercalname" &&
	echo "What would you like to name the calibration file?" &&
	read filename && #variable for command
	echo "Thanks! Pulling up calibration graphs. When you exit, the terminal will query if you want to it log to the eVOLVER." &&
	echo "If you log it, it will be available for experiments under $filename temp." 
	echo "Fetching temperature calibration, one set of linear-fit calibration curves will appear" &&
	echo "After exiting the graphing interface, the terminal will query if you wish to log each to the eVOLVER." &&
	$pythoncall $directory -a $evolverip -n $evolvercalname -t linear -f "$filename temp" -p temp
	pause 'Temperature Calibration Fit, Press [Enter] key to return to menu...'
	show_menus
}
#automates calling eVOLVER.py from the command line
#could easily incorporate additional querys for parser variables inside eVOLVER.py or even the custom script to generate a menu of options from user functions
RunExperiment(){
	echo "Run Experiment Selected"
		echo "Is the custom script set up appropriately?"    
		pause
		#echo "What is the path to eVOLVER.py directory (/experiments/expt-dir) ?" &&
		#read evolverpypath &&
		#cd $evolverpypath && #move into the user-defined script directory
		cd ./experiment/expt-dir
		echo "Thanks! Running Experiment" &&
		sudo $pythoncall eVOLVER.py
		pause 'Experiment terminated, Press [Enter] key to return to menu...'
		show_menus
}
#opens electron shell
#this assumes appropriate set up has been done
#if the user has the dpu nested inside a direcotry with the other eVOVLER repos, this code should work as is
OpenElectronShell(){
	echo "Open Electron Shell Selected"
		cd ../evolver-electron && #cd back into repo parent directory and into the electron folder; replace with whatever path is appropriate for your system
		yarn dev #initiates electron shell
		show_menus
} 
#initiates graphing utility server
GraphingUtility(){
	echo "Graphing Utility Selected"
		#echo "What is the path to the graphing_utility (/experiment/graphing/src)?"  &&
		#read graphpypath &&
		cd ./graphing/src && #move into the user-defined script directory
		#cd /path/to/graphing/src &&
		sudo $pythoncall manage.py runserver
		show_menus
}

 
# Trap CTRL+Z and quit singles
trap '' SIGQUIT SIGTSTP
 
# infinite loop
while true
do
 
	show_menus
	read_options
done
