<#
.SYNOPSIS
  Processes manual magstrip data.

.DESCRIPTION
  This module/script processes the data generated 
  from magstrip cards. It's meant to process manual
  on-screen entry typed in from a "USB emulation 
  keyboard interface" magstrip reader like the
  MSR90 USB magnetic cc reader.

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
  Process-ManualMagData -CardInfo $ManualCardInfo -OutputDirectory $ManualEntryDirectoryPath -MagFileHeader $MagFileHeader

  Processes the data captured in $ManualCardInfo (likely using the Read-UserInput function) and
  outputs the individual cards to wherever $ManualEntryDirectoryPath is set (in invoke-magspoofcardorganizer.ps1)
  using the $MagFileHeader. $MagFileHead is the top lines of the .mag files.
#>
#Created by FatherDivine & ChatGPT 3/5/2024
function Read-UserInput {
    begin {
        $userInput = @() # Initialize an array to hold user input
        $i = 1
    }
    
    process {
        Write-Verbose "Start scanning cards (Type 'Stop' to stop reading):" -Verbose

        do {
            $inputLine = Read-Host "Card $i (Separate multiple cards with '|')"
            if ($inputLine -ne 'Stop') {
                $userInput += $inputLine
                $i++
            }
        } while ($inputLine -ne 'Stop')

        Write-Verbose "`nYou entered 'Stop'. Stopping input." -Verbose
    }

    end {
        return $userInput -join '|' # Join multiple inputs with '|' as a delimiter
    }
}