@echo off & setlocal enableextensions disabledelayedexpansion
(call;)
rem For User Input
echo What is the path to the dpu root folder? (C:\path\to\dpu) 
set /p dpupath=
cd %dpupath%
C:\path\to\repo\dpu
echo Thank you, please set the appropriate python call (python3):
set /p pythoncall=
rem For Standard Values Across Script Runs
rem pythoncall = python3
rem cd C:\path\to\repo\dpu
rem main menu from which options can be chosen
:menu
title Menu
(set lf=^
%= DO NOT DELETE =%
)
set ^"nl=^^^%lf%%lf%^%lf%%lf%^"
set ^"\n=^^^%lf%%lf%^%lf%%lf%^^"

cls
echo(Choose an Option:%nl%%\n%
  1. Log Calibration%nl%%\n%
  2. Run Experiment%nl%%\n%
  3. Open Elecrtron Shell%nl%%\n%
  4. Graphing Utility%nl%%\n%
  0. Quit

rem reads input from menu and goes to right code for action
:readKey
set "opt=" & for /f skip^=1^ delims^=^ eol^= %%A in ('
replace ? . /u /w
') do if not defined opt set "opt=%%A"

set opt | findstr /ix "opt=[01234]" >nul || goto readKey

if %opt% equ 0 goto bye
if %opt% equ 1 goto logcal
if %opt% equ 2 goto runexp
if %opt% equ 3 goto ecsh
if %opt% equ 4 goto graph

rem calibration code up to end where it splits based on whether an OD or temperature calibration are ebing logged
:logcal 
title Log Calibration
rem For Standard Values Across Runs of Script
directory = .\calibrate\calibrate.py
rem evolverip = 192.168.1.2
rem For User Input
rem echo What is the path to the calibration python script (/calibration/calibrate.py)?
rem set /p directory=
rem echo The calibration python script will be called through %directory%
echo Please provide eVOLVER IP address (192.168.1.2):
set /p evolverip=
echo Temperature or OD calibration? Input 'temp' or 'OD'
set /p caltype=
echo Thanks! Fetching calibrations
%pythoncall% %directory% -a %evolverip% -g
echo Enter  appropriate %caltype% calibration name from the above list:
set /p evolvercalname=
echo Calibration name is %evolvercalname%
echo Enter name to log calibration under (INITIALS_YYMMDD):
set /p filename=
echo Thanks! Pulling up calibration graphs. When you exit, the terminal will query if you want to it log to the eVOLVER.
echo If you log it, it will be available for experiments under %filename% with a tag for the accompanying type.
if %caltype% == temp goto :tempcal
if %caltype% == OD goto :odcal

rem runs temperature calibration script automatically
:tempcal
title Fitting Temperature Calibration...
echo Fetching temperature calibration, only one set of graphs will appear 
%pythoncall% %directory% -a %evolverip% -n %evolvercalname% -t linear -f %filename%_temp -p %caltype% 
goto :done

rem runs all three OD calibration scripts automatically
:ODcal
title Fitting OD Calibrations...
echo Three graphs for sigmoid-fit OD90, sigmoid-fit OD135, and the 3D-fit calibration curves will be sequentially generated 
echo After exiting the graphing interface, the terminal will query if you wish to log each fit to the eVOLVER.
echo Fetching calibrations...
%pythoncall% %directory% -a %evolverip% -n %evolvercalname% -t sigmoid -f %filename%_od90 -p od_90 
%pythoncall% %directory% -a %evolverip% -n %evolvercalname% -t sigmoid -f %filename%_od135 -p od_135  
%pythoncall% %directory% -a %evolverip% -n %evolvercalname% -t 3d -f %filename%_3dfit -p od_90,od_135 
goto :done

rem runs experiments
rem if standard repo is used, no user input is needed
rem in future versions of the dpu release, hopefully parser in the custom script and eVOLVER.py can incorporate user input from the CLI
:runexp
title Running Experiment...
rem For Runs with Standard path
cd .\experiments\expt-dir
rem for User Input
rem echo What is the path to eVOLVER.py directory(.\experiments\expt-dir)?
rem set /p evolverpypath=
echo Thanks! Running experiment...
rem cd %evolverpypath% 
%pythoncall% eVOLVER.py
goto :done

:graph
title Running Graphing Utility...
rem For Runs with Standard path
cd .\experiments\graphing\src
rem for User Input
rem echo What is the path to the graphing_utility (/experiments/graphing/src)?
rem set /p graphpypath=  
rem cd graphpypath 
%pythoncall% manage.py runserver
goto :done

:ecsh
title Running Electron Shell...
rem For Runs with Standard path
cd ../evolver-electron 
rem for User Input
rem echo "Please input path to the eVOLVER Electron Utility"
rem set /p ecshpath=
rem cd %ecshpath%
yarn dev
goto :done

:done
title %opt% Completed
echo Return to main menu or exit terminal? (input 'menu' or 'bye')
set /p helpbool=
if %helpbool% == menu goto :menu
if %helpbool% == bye echo Thanks for using the CLI and have a great day!
if %helpbool% == bye pause; goto :bye

:bye
exit /b 0

rem	echo "Thanks! Which port on $evolverip (8081)?" 
rem	set /p evolverport 
rem	echo "Please provide eVOLVER IP address (192.168.1.2):"  /
rem	echo "If unknown, press the eVOLVER name on the Raspberry Pi/Electron home screen"  /
rem	set /p evolverip
rem	echo "Thanks! Which port on $evolverip (8081)?"  /
rem	set /p evolverport
rem	echo "Experiment Name:"  /
rem	set /p caltype
rem	echo "Experiment Type (list of options):"  /
rem	call list of functions somehow
rem	echo anything else we need
rem	input variables into custom script somehow 