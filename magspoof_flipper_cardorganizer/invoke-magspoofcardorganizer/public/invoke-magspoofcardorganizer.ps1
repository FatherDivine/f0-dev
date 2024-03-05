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

.PARAMETER Filename
    For loading a file that already has data. This file
    can be named anything (.txt, log, no extension). Just
    make sure you load the data into that file card after
    card in the native format the card reader writes (meaning
    don't press enter or any buttons in between card reads).

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

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

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "0.1"

#Variables
$date = Get-Date -Format "-MM-dd-yyyy-HH-mm"

#Log File Info
$sLogPath = "C:\Windows\Logs\magspoof_flipper_cardorganizer"
$sLogName = "invoke-magspoofcardorganizer$date.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function invoke-magspoofcardorganizer{
 # Param()
<#
  .PARAMETER ComputerName
    Allows for QuickFix to be ran against a remote PC or list of
    remote PCs.
#>
  [cmdletbinding()]
  Param(
    [Alias("file")]
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]$FileName = $null
 ) 
  Begin{
    #Start logging
    Start-Transcript -Path $sLogFile -Force
    Write-Verbose "`n
    ***************************************************************************************************`n`r
    Started processing at $([DateTime]::Now).`n`r
    ***************************************************************************************************`n`r
    `n`r
    Running script version $ScriptVersion.`n`r
    `n`r
    ***************************************************************************************************`n`r
    " -Verbose    
  }

  Process{
    Try{

    }

    Catch{
      Write-Verbose "$_.Exception" -Verbose
      Break
    }
  }

  End{
    If($?){
      Write-Verbose "invoke-magspoofcardorganizer function completely successfully."
      Write-Verbose " " -Verbose
      Read-Host -Prompt "Press Enter to exit"
      Stop-Transcript
    }
  }
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Script Execution goes here, when not using as a Module