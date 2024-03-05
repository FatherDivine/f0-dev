#Template design originally remixed from https://github.com/MSAdministrator/TemplatePowerShellModule
<#
.SYNOPSIS
  Organizes magspoof-based data.

.DESCRIPTION
  This module/script oraganizes the data 
  generated from the magspoof app, particularly
  the version for the flipper zero. Version 0.1
  of this module is based on the "MSR90 USB 
  Swipe Magnetic Credit Card Reader 3 Tracks Mini 
  Smart Card Reader MSR605 MSR606" sold by Deftun
  on Amazon. A link to the device is found in the
  readme.md.

  What makes this device special is that it's a
  "USB emulation keyboard interface" that requires
  no driver or software. The reader basically emulates
  a keyboard. Just plug the device, open a notepad/app 
  (or in this case this app) and the card data will
  write directly onto whatever has your cursor's attention.

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  Logs are stored in C:\Windows\Logs\magspoof_flipper_cardorganizer

.NOTES
  Version:        0.1
  Author:         Father Divine
  Creation Date:  3/4/2024
  Purpose/Change: Initial script development

.LINK
https://github.com/fatherdivine/f0-dev/tree/main/magspoof_flipper_cardorganizer

.EXAMPLE
  invoke-magspoofcardorganizer -filepath c:\users\username\desktop\magspoof.dump

  Opens a file for organizing

.EXAMPLE
  invoke-magspoofcardorganizer -file c:\magspoofcards.txt

  Opens a file for organizing (using the file alias for filepath)

.EXAMPLE
  test.
#>
#---------------------------------------------------------[Force Module Elevation]--------------------------------------------------------
#With this code, the script/module/function won't run unless elevated, thus local users can't use off the bat.
<#
$Elevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ( -not $Elevated ) {
  throw "This module requires elevation."
}
#>

#--------------------------------------------------------------[Privilege Escalation]---------------------------------------------------------------

#When admin rights are needed
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

#---------------------------------------------------------[Initialisations & Declarations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Create the Log folder if non-existant
If (!(Test-Path "C:\Windows\Logs\magspoof_flipper_cardorganizer")){New-Item -ItemType Directory "C:\Windows\Logs\magspoof_flipper_cardorganizer\" -Force}

#Script Version
$sScriptVersion = "0.1"

#Variables
$date = Get-Date -Format "-MM-dd-yyyy-HH-mm"
$directoryPath = "C:\temp\mags\"
$ManualEntryDirectoryPath = "C:\temp\mags\manualentry\"
#$filePattern = "*.mag"

$MagFileHeader= @(
'#Created with invoke-magspoofcardorganizer.ps1 
Filetype: Flipper Mag device
Version: 1
# Mag device track data
Track 1: '
)

#Log File Info
$sLogPath = "C:\Windows\Logs\magspoof_flipper_cardorganizer"
$sLogName = "invoke-magspoofcardorganizer$date.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#Aliases
New-Alias -Name magorganizer -value invoke-magspoofcardorganizer -Description "Organizes magspoof-based data."

#-----------------------------------------------------------[Functions]------------------------------------------------------------
function invoke-magspoofcardorganizer
{
<#
  .PARAMETER Filename
    For loading a file that already has data. This file
    can be named anything (.txt, log, no extension). Just
    make sure you load the data into that file card after
    card in the native format the card reader writes (meaning
    don't press enter or any buttons in between card reads).
  .EXAMPLE
    invoke-magspoofcardorganizer -Filename "C:\mags\mags.dump"

    This will load a file named "mags.dump" into the script 
    for processing. The script will split each line into
    separate files (for each individual mag card) and also
    put each track into it's own track line. The best way to
    make a dump is just open notepad and start scanning cards
    on a HID-enabled reader (like the MSR90). It will output
    all the data to that notepad. Just save and load in this
    script.

#>
  [cmdletbinding()]
  param(
    [Alias("file")]
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]$FileName = $null,
    [string]$Path="$env:temp\magspoofdata.dump" 
  )
  begin{

  #Start logging
  Start-Transcript -Path $sLogFile -Force
  Write-Verbose "`n
  ***************************************************************************************************`n`r
  Started processing at $([DateTime]::Now).`n`r
  ***************************************************************************************************`n`r
  `n`r
  Running script version $sScriptVersion.`n`r
  `n`r
  ***************************************************************************************************`n`r
  " -Verbose
}
  process{
    If ($null -eq $FileName){ 

      #Grab the user input using a private function and bring it back here for processing
      $ManualCardInfo = Read-UserInput
      Write-Verbose "User input captured: $ManualCardInfo" -Verbose

      #Process the manual card info and save to file
      Process-ManualMagData -CardInfo $ManualCardInfo -OutputDirectory $ManualEntryDirectoryPath -MagFileHeader $MagFileHeader

    }else{

      #Process mag data based on the filename provided
      Process-MagData -FileName $FileName -OutputDirectory $directoryPath -MagFileHeader $MagFileHeader
    }
  }

  End{
    If($?){
      Write-Verbose "invoke-magspoofcardorganizer function completely successfully." -Verbose
      clear-variable -Name FileData, path
      Stop-Transcript
      Read-Host -Prompt "Press Enter to exit"
    }
  }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------
#invoke-magspoofcardorganizer -Filename "C:\mags\mags.dump"
#Script Execution goes here, when not using as a Module
export-modulemember -alias * -function *