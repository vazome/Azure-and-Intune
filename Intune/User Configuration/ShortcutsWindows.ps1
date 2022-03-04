$ErrorActionPreference = 'SilentlyContinue'

# Probably I shoud convert it to functions

# Lets create this shortcut from scractch

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\7-Zip.lnk")
$Shortcut.TargetPath = "C:\Program Files\7-Zip\7zFM.exe"
$Shortcut.Save()

#Create Microsoft Store's Company Portal app shortcut
$TargetPath =  "shell:AppsFolder\Microsoft.CompanyPortal_8wekyb3d8bbwe!App"
$ShortcutFile = "C:\Users\Public\Desktop\Company Portal.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetPath
$Shortcut.Save()

# Copy shortcuts to Desktop
$Inks = @(
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyDesk Custom Client\AnyDesk Custom Client.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Drive.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Cisco\Cisco AnyConnect Secure Mobility Client\Cisco AnyConnect Secure Mobility Client.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Access.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
    "C:\Users\$([Environment]::UserName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Jira IT HelpDesk.url"
    )

foreach ($ink in $Inks) {
    Copy-Item $ink -Destination "$Home\Desktop"
}

# Development purpose only - find Microsoft Store App name and shortcut
#$InstalledApps = Get-AppxPackage
#$AUMIDList = @()
#ForEach ($App in $InstalledApps) {
#
#    ForEach ($id in (Get-AppxPackageManifest $app).Package.Applications.Application.ID) {
#
#        $AUMIDList += $App.PackageFamilyName + "!" + $id
#
#    }
#
#}
#$AUMID = $AUMIDList  | Where-Object { $_ -like "*Portal*" }
#$AUMID

stop-process -name explorer -force

