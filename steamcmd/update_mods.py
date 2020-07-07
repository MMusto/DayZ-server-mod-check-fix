import os
import subprocess
STEAM_USER_NAME = 'STEAM_USER_HERE'
MODLIST_FILE_LOCATION = 'C:\Modlist.txt'          
SCRIPT_FILE_LOCATION = 'C:\steamcmd\script.txt' 
update_ids = []
           
#Get id of mods that need to be updated
#stream = os.popen('C:\steamcmd\steamcmd.exe +runscript getstatus.txt +quit')
#output = stream.readlines()
result = subprocess.run('C:\steamcmd\steamcmd.exe +runscript getstatus.txt +quit', stdout=subprocess.PIPE)

for line in result.stdout.decode("utf-8").split('\n'):
    line = line.split()
    if len(line) > 1:
        if line[0] == '-':
            if 'updated' in line and 'required(' in line:
                update_ids.append(line[2].strip())

if os.path.exists(SCRIPT_FILE_LOCATION):
    os.remove(SCRIPT_FILE_LOCATION)  
    
with open(SCRIPT_FILE_LOCATION, 'w+') as new_runscipt:
    mods_to_update = []
    with open(MODLIST_FILE_LOCATION) as mods:
        for line in mods.readlines():
            if len(line.strip()) > 0:
                mod_id, mod_name = line.split(',')
                print(mod_id, mod_name)
                if mod_id in update_ids:
                    print(f"[!] UPDATE REQUIRED FOR : {mod_name}")
                    mods_to_update.append(mod_id)                
    if mods_to_update:
        new_runscipt.write(f"login {STEAM_USER_NAME}\n")
        for mod_id in mods_to_update:
            new_runscipt.write(f"workshop_download_item 221100 {mod_id}\n")
    else:
        print("[INFO] No mod updates found!")
os.system('pause')