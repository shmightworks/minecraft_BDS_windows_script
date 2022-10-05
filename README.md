# minecraft_BDS_windows_script
powershell script to install/update/backup your windows minecraft bedrock server

This script will do the following:
-Stop the running bedrock_server
-Backup the worlds folder and *.json and *.properties in a zip (you can set the folder to be somewhere in your FTP server to offload your backups)
-Check https://www.minecraft.net/en-us/download/server/bedrock for the latest version
-If the latest version isn't downloaded, then initiate update:
  Download the latest server zip
  Backup the full server in a zip
  Preserve *.json and *.properties
  Update the server
  Restore the preserved *.json and *.properties
-Finally runs the server

How to use:
You can run this script anywhere, just make a folder for it, and it'll create all the needed folders.
Edit the first couple lines to get the correct paths for your server's setup.
Add a Task Scheduler task to run this script.  I run this everyday at 3am.
  Make sure you set the task to run in highest privileges, run as administrator, else it might have issue stopping the running server.
  For the Action, put in "powershell" in the "Program/script", and put in "-File C:\PathToTheScript\MinecraftBDSBackupUpdate.ps1" in the "Add arguments"

Cheers
