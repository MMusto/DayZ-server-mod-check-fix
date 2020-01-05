@echo off
TITLE STS DayZ Server
COLOR 0B
:: Parameters::
::DayZ Parameters
set DAYZ-SA_SERVER_LOCATION="C:\DayZServer"
set DAYZ-SAL_NAME=DZSALModServer.exe
set LOG_LOCATION=C:\ServerLogs
set DAYZSERVER_APPID=223350
set PORT_NUM=2302
::
::Battleye Parameters
set BE_FOLDER="C:\DayZServer\battleye"
set BEC_LOCATION="C:\DayZServer\battleye\Bec"
::
::ModCheck Parameters
set MOD_LIST=(C:\Modlist.txt)
set STEAM_WORKSHOP="C:\steamcmd\steamapps\workshop\content\221100"
set STEAMCMD_LOCATION="C:\steamcmd"
set STEAM_USER="Your username here"
set STEAMCMD_DEL=3
setlocal EnableDelayedExpansion
::::::::::::::
goto checksv
pause

:checksv
tasklist /FI "IMAGENAME eq %DAYZ-SAL_NAME%" 2>NUL | find /I /N "%DAYZ-SAL_NAME%">NUL
if "%ERRORLEVEL%"=="0" goto checkbec
cls
echo Server is not running, taking care of it..
goto killsv

:checkbec
tasklist /FI "IMAGENAME eq Bec.exe" 2>NUL | find /I /N "Bec.exe">NUL
if "%ERRORLEVEL%"=="0" goto loopsv
cls
echo Bec is not running, taking care of it..
goto startbec

:loopsv
FOR /L %%s IN (30,-1,0) DO (
	cls
	echo Server is running. Checking again in %%s seconds.. 
	timeout 1 >nul
)
goto checksv

:killsv
taskkill /f /im Bec.exe
taskkill /f /im %DAYZ-SAL_NAME%
goto checkmods

:startsv
cls
echo Starting DayZ SA Server.
timeout 1 >nul
cls
echo Starting DayZ SA Server..
timeout 1 >nul
cls
echo Starting DayZ SA Server...
cd "%DAYZ-SA_SERVER_LOCATION%"
start %DAYZ-SAL_NAME% -config=serverDZ.cfg -port=%PORT_NUM% -freezecheck -BEpath=%BE_FOLDER% -profiles=STS "-mod=!MODS_TO_LOAD!%" "-scrAllowFileWrite"
FOR /L %%s IN (30,-1,0) DO (
	cls
	echo Initializing server, wait %%s seconds to initialize check again.. 
	timeout 1 >nul
)
goto startbec

:startbec
cls
echo Starting Bec.
timeout 1 >nul
cls
echo Starting Bec..
timeout 1 >nul
cls
echo Starting Bec...
timeout 1 >nul
cd "%BEC_LOCATION%"
start Bec.exe -f Config.cfg
goto checksv

:checkmods
cls

echo.
echo     Checking for DayZ server update
echo        DayZ Server Dir: %DAYZ-SA_SERVER_LOCATION%
echo        SteamCMD Dir: %STEAMCMD_LOCATION%
echo.
%STEAMCMD_LOCATION%\steamcmd.exe +login %STEAM_USER% +force_install_dir %DAYZ-SA_SERVER_LOCATION% +"app_update %DAYZSERVER_APPID%" +quit
echo .
echo     Your DayZ server is up to date
cls
echo Updating DayZ Workshop mods...
@ timeout 1 > nul
cd %STEAMCMD_LOCATION%
echo Running Pyhon mod update fix...
start /b /WAIT update_mods.py
::steamcmd.exe +runscript script.txt +quit ::I put this line inside the python file
echo DayZ mods up to date! Syncing mods with server mods...
@ timeout 1 >nul
cls
@echo off
@ for /f "tokens=1,2 delims=," %%g in %MOD_LIST% do robocopy "%STEAM_WORKSHOP%\%%g" "%DAYZ-SA_SERVER_LOCATION%\%%h" *.* /mir
@ for /f "tokens=1,2 delims=," %%g in %MOD_LIST% do forfiles /p "%DAYZ-SA_SERVER_LOCATION%\%%h" /m *.bikey /s /c "cmd /c copy @path %DAYZ-SA_SERVER_LOCATION%\keys"
cls
echo Sync complete! If sync not completed correctly, verify configuration file.
@ timeout 1 >nul
cls
set "MODS_TO_LOAD="
for /f "tokens=1,2 delims=," %%g in %MOD_LIST% do (
set "MODS_TO_LOAD=!MODS_TO_LOAD!%%h;"
)
set "MODS_TO_LOAD=!MODS_TO_LOAD:~0,-1!"
ECHO Will start DayZ with the following mods: !MODS_TO_LOAD!%
@ timeout 1 >nul
goto startsv