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

#Script Version
$sScriptVersion = "0.1"

#Log File Info
$sLogPath = "C:\Windows\Logs\magspoof_flipper_cardorganizer"
$sLogName = "invoke-magspoofcardorganizer$date.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName


#Variables
$date = Get-Date -Format "-MM-dd-yyyy-HH-mm"
$i = 0

$MagFileHeader= @(
'#Added by invoke-magspoofcardorganizer.ps1
Filetype: Flipper Mag device
Version: 1
# Mag device track data
Track 1: '
)

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
    # Signatures for API Calls
    $signatures = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int GetKeyboardState(byte[] keystate);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int MapVirtualKey(uint uCode, int uMapType);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

  # load signatures and make members available
  $API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru
    
  # create output file
  $null = New-Item -Path $Path -ItemType File -Force

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
  process{
    If ($null -eq $FileName){  
      try{
        Write-Host 'Recording key presses. Press CTRL+C to see results.' -ForegroundColor Red

        # create endless loop. When user presses CTRL+C, finally-block
        # executes and shows the collected key presses
        while ($true) {
          Start-Sleep -Milliseconds 40
      
          # scan all ASCII codes above 8
          for ($ascii = 9; $ascii -le 254; $ascii++) {
            # get current key state
            $state = $API::GetAsyncKeyState($ascii)

            # is key pressed?
            if ($state -eq -32767) {
              $null = [console]::CapsLock

              # translate scan code to real code
              $virtualKey = $API::MapVirtualKey($ascii, 3)

              # get keyboard state for virtual keys
              $kbstate = New-Object Byte[] 256
              $checkkbstate = $API::GetKeyboardState($kbstate)

              # prepare a StringBuilder to receive input key
              $mychar = New-Object -TypeName System.Text.StringBuilder

              # translate virtual key
              $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

              if ($success) 
              {
                # add key to logger file
                System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode) 
              }
            }
          }
        }
      }
      finally
      {
        Write-Verbose "Let's read the file:"+Get-Content $Path -Verbose
    
        Get-Content $Path
        # open logger file in Notepad
        #notepad $Path
      }
    }else{
      $testdata = Get-Content $FileName
      write-verbose "The data first: $testdata" -Verbose
      #Load the file
      $FileData = Get-Content $FileName | foreach {if(!$_.StartsWith("#")){$i++;$tempdata = $_ ;New-Item -Path C:\temp\ -Name "test$i.txt" -Value "$MagFileHeader$_" -Force}}

      Write-Verbose "Data: $FileData" -Verbose
      Read-Host "Pause"

      #Ask if auto mode or manual. Auto splits the data to separate cards with a +1 to the # at end
      #manual asks for the name scheme and does it using that.




    }
  }

  End{
    If($?){
      Write-Verbose "invoke-magspoofcardorganizer function completely successfully." -Verbose
      Write-Verbose " " -Verbose
      clear-variable -Name FileData, path
      Stop-Transcript
      Read-Host -Prompt "Press Enter to exit"
    }
  }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------
invoke-magspoofcardorganizer -Filename "C:\mags\mags.dump"
#Script Execution goes here, when not using as a Module
export-modulemember -alias * -function *
