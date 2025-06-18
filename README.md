# minecraft_BDS_windows_script
powershell script to install/update/backup your windows minecraft bedrock server

This script will do the following:<br />
-Stop the running bedrock_server<br />
-Backup the worlds folder and *.json and *.properties in a zip (you can set the folder to be somewhere in your FTP server to offload your backups)<br />
~-Check https://www.minecraft.net/en-us/download/server/bedrock for the latest version<br />~
-Check https://net-secondary.web.minecraft-services.net/api/v1.0/download/links for latest version <br />
-If the latest version isn't downloaded, then initiate update:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Download the latest server zip<br />
&nbsp;&nbsp;&nbsp;&nbsp;Backup the full server in a zip<br />
&nbsp;&nbsp;&nbsp;&nbsp;Preserve *.json and *.properties<br />
&nbsp;&nbsp;&nbsp;&nbsp;Update the server<br />
&nbsp;&nbsp;&nbsp;&nbsp;Restore the preserved *.json and *.properties<br />
-Finally runs the server<br />
<br />
How to use:<br />
You can run this script anywhere, just make a folder for it, and it'll create all the needed folders.<br />
Edit the first couple lines to get the correct paths for your server's setup.<br />
Add a Task Scheduler task to run this script.  I run this everyday at 3am.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Make sure you set the task to run in highest privileges, run as administrator, else it might have issue stopping the running server.<br />
&nbsp;&nbsp;&nbsp;&nbsp;For the Action, put in "powershell" in the "Program/script", and put in "-File C:\PathToTheScript\MinecraftBDSBackupUpdate.ps1" in the "Add arguments"<br />
<br />
Cheers
