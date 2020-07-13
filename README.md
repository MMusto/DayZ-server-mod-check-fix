# DayZ-server-mod-check-fix
 This python script uses steamcmd to check which mods require updating, and downloads only the mods which need updating, as opposed to downloading ALL mods every restart. It does this by creating a text file "script.txt" with only the mods that require updating which can then be run from a steamcmd command such as:
 [code]steamcmd.exe +runscript script.txt +quit[/code]

Requirements:
- Python 3.8+ with python in PATH
- Must run your start server script as administrator

If you want help setting up this script, feel free to join our discord: https://discord.gg/a2SZD3D
