$ServerSuffix = ""
$MinecraftServerPath = "C:\minecraft"
$BackupPath = "C:\FTP\MinecraftBackups"
$DTNow = get-date
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$WorldBackupPath = $BackupPath + "\minecraftworld_" + $DTNow.ToString("yyyyMMdd-HHmm") + ".zip"
$FullBackupPath = $BackupPath+ "\minecraft_" + $DTNow.ToString("yyyyMMdd-HHmm") + ".zip"

#make any missing dir
if(!(Test-Path -path "$MinecraftServerPath")){
    New-Item -Path "$MinecraftServerPath" -ItemType Directory
}
if(!(Test-Path -path "$BackupPath")){
    New-Item -Path "$BackupPath" -ItemType Directory
}
if(!(Test-Path -path "$MinecraftServerPath\backup")){
    New-Item -Path "$MinecraftServerPath\backup" -ItemType Directory
}
$ConfigBackupPath = $MinecraftServerPath + "\backup"
if(!(Test-Path -path "$ScriptPath\logs")){
    New-Item -Path "$ScriptPath\logs" -ItemType Directory
}
$LogPath = $ScriptPath + "\logs\" + $DTNow.ToString("yyyyMMdd-HHmm") + ".log"
if(!(Test-Path -path "$ScriptPath\Downloads")){
    New-Item -Path "$ScriptPath\Downloads" -ItemType Directory
}
$DownloadPath = $ScriptPath + "\Downloads$ServerSuffix\"
if(!(Test-Path -path "$DownloadPath")){
    New-Item -Path "$DownloadPath" -ItemType Directory
}

#log
Start-Transcript -Path $LogPath

#stop server
$serverprocess = Get-Process "bedrock_server$ServerSuffix" -ErrorAction SilentlyContinue
if ($serverprocess) {	
	write-host "Stopping Server" -ForegroundColor Yellow
	Stop-Process -Force -Name "bedrock_server$ServerSuffix"  -ErrorAction SilentlyContinue
	start-sleep -s 2
	#double check if it's still running
	$serverprocess = Get-Process "bedrock_server$ServerSuffix" -ErrorAction SilentlyContinue
}


#backup world
if((Test-Path -path "$MinecraftServerPath\worlds")){
	#only if it's not running
	if (!($serverprocess)){
		write-host "Backup Worlds and Configurations" -ForegroundColor Yellow
		Compress-Archive -Path "$MinecraftServerPath\worlds" -DestinationPath "$WorldBackupPath"
		Compress-Archive -Path "$MinecraftServerPath\*.json" -Update -DestinationPath "$WorldBackupPath"
		Compress-Archive -Path "$MinecraftServerPath\*.properties" -Update -DestinationPath "$WorldBackupPath"
	}
}

#check latest version
write-host "Checking Latest Version" -ForegroundColor Yellow
#$request = Invoke-Webrequest -Uri "https://www.minecraft.net/en-us/download/server/bedrock" -UseBasicParsing
#$download_link = $request.Links | ? class -match "btn" | ? href -match "bin-win/bedrock" | select -ExpandProperty href
$json = Invoke-Webrequest -Uri "https://net-secondary.web.minecraft-services.net/api/v1.0/download/links" -UseBasicParsing | ConvertFrom-Json 
$download_link = $json.result.links.Where{$_.downloadType -eq "serverBedrockWindows"}.downloadUrl
$latest_server_zipfile = $download_link.split("/")[5]
write-host "Latest Version: $($latest_server_zipfile)" -ForegroundColor Yellow

#check if latest is downloaded
if(!(Test-Path -path "$DownloadPath\$latest_server_zipfile")){
	write-host "Latest Version Not Found: $($latest_server_zipfile)" -ForegroundColor Yellow
    write-host "Downloading: $($latest_server_zipfile)" -ForegroundColor Yellow
	$ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $download_link -OutFile "$DownloadPath\$latest_server_zipfile" -UseBasicParsing
	
	write-host "Backup Server" -ForegroundColor Yellow
	Compress-Archive -Path "$MinecraftServerPath" -DestinationPath "$FullBackupPath"
	
	write-host "Backup Configurations For Restore After Update" -ForegroundColor Yellow
	Copy-Item "$MinecraftServerPath\*.json" -Destination $ConfigBackupPath -Force
	Copy-Item "$MinecraftServerPath\*.properties" -Destination $ConfigBackupPath -Force
	
    write-host "Extracting: $($latest_server_zipfile)" -ForegroundColor Yellow
    Expand-Archive -Path "$DownloadPath\$latest_server_zipfile" -DestinationPath $MinecraftServerPath -Force
	
	write-host "Restore Configurations" -ForegroundColor Yellow
	Copy-Item "$ConfigBackupPath\*.json" -Destination $MinecraftServerPath -Force
	Copy-Item "$ConfigBackupPath\*.properties" -Destination $MinecraftServerPath -Force
	Move-Item -Path "$MinecraftServerPath\bedrock_server.exe" -Destination "$MinecraftServerPath\bedrock_server$ServerSuffix.exe" -Force
}
else {
	write-host "Server Up To Date" -ForegroundColor Yellow
}

write-host "Running Server" -ForegroundColor Yellow
Start-Process -FilePath "$MinecraftServerPath\bedrock_server$ServerSuffix.exe"

write-host "Done" -ForegroundColor Yellow
Stop-Transcript
