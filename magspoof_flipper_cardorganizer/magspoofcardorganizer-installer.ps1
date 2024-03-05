<#
.SYNOPSIS
  Installs the magspoofcardorganizer module.

.DESCRIPTION
  This script installs the magspoofcardorganizer module.

.INPUTS
  none

.OUTPUTS
  Logs are stored in C:\Windows\Logs\magspoof_flipper_cardorganizer.

.NOTES
  Version:        0.1
  Author:         Aaron Staten
  Creation Date:  3/5/2024
  Purpose:        For installing magspoofcardorganizer module easily.

.LINK
https://github.com/FatherDivine/f0-dev/tree/main/magspoof_flipper_cardorganizer
.EXAMPLE
  & .\magspoofcardorganizer-installer.ps1
#>
#----------------------------------------------------------[Initialization & Declarations]----------------------------------------------------------

#Variable declaration
$date = Get-Date -Format "-MM-dd-yyyy-HH-mm"
$Module = 'magspoofcardorganizer'

#Start Logging
Start-Transcript -Path "C:\Windows\Logs\magspoof_flipper_cardorganizer\Install-magspoofcardorganizer$date.log"

#-----------------------------------------------------------[Execution]------------------------------------------------------------
#Download the latest version of the modules & script(s) via Github if module is non-existant
#If (!(Test-Path "C:\Program Files\WindowsPowerShell\Modules\$Module")){
  Write-Verbose "Downloading the latest $Module module and placing in C:\Program Files\WindowsPowerShell\Modules\$Module\" -Verbose
  try{
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/magspoofcardorganizer.psd1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\$Module.psd1" -Force)
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/magspoofcardorganizer.psm1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\$Module.psm1" -Force)
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/public/invoke-magspoofcardorganizer.ps1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\Public\invoke-magspoofcardorganizer.ps1" -Force)
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/private/Process-MagData.ps1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\Private\Process-MagData.ps1" -Force)
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/private/Process-ManualMagData.ps1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\Private\Process-ManualMagData.ps1" -Force)
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FatherDivine/f0-dev/main/magspoof_flipper_cardorganizer/magspoofcardorganizer/private/Read-UserInput.ps1" -OutFile (New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\$Module\Private\Read-UserInput.ps1" -Force)
  }catch{Write-Verbose "Error detected! : $_" -Verbose}
#}

#Stop logging
Write-Verbose "Module download complete!" -Verbose
Stop-Transcript

#Housekeeping
#Remove-Item -Path $MyInvocation.MyCommand.Source
exit