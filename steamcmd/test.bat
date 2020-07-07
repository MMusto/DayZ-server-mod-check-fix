
setlocal EnableDelayedExpansion
:starttest
echo Running Python mod update fix...
start /b /WAIT update_mods.py
echo DayZ mods up to date! Syncing mods with server mods...
echo doing loop

FOR /L %%s IN (5,-1,0) DO (
	cls
	echo Initializing server, wait %%s seconds to initialize check again.. 
	timeout 1 >nul
)
goto starttest