param(
      [string]$registrationToken
)

#Extract MSIs
Expand-Archive -path .\Agents.zip 
$msiFile =  Get-ChildItem .\Agents -name 'Microsoft.RDInfra.RDAgent.Installer*'

write-host $msiFile


$execarg = @(
    "/i"
    ".\Agents\$msiFile"
    "/passive"
    " REGISTRATIONTOKEN=$registrationToken"
)

write-host "Installing RDAgent..."
Start-Process msiexec.exe -Wait -ArgumentList $execarg

write-host "Verifiying RDAgent registry keys"

if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent") -eq $false) {(Start-Sleep -s 60)} ELSE {write-host "RDinfraAgent Registry entry found"}
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent"

write-host "Installing BootLoader..."
$execarg = @(
    "/i"
    ".\Agents\Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi" 
    "/passive"
    " REGISTRATIONTOKEN=$registrationToken"
)
Start-Process msiexec.exe -Wait -ArgumentList $execarg

if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\RDAgentBootLoader") -eq $false) {(Start-Sleep -s 60)} ELSE {write-host "RDAgentBootLoader Registry entry found"}
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\RDAgentBootLoader"

write-host "Installation completed"


