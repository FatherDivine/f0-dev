<#
.SYNOPSIS
  Reads user input.

.DESCRIPTION
  This module/script reads the user's manual magstrip
  data from magstrip cards. This data is supplied via
  on-screen entry typed in from a "USB emulation
  keyboard interface" magstrip reader like the
  MSR90 USB magnetic cc reader.

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  Logs are stored in C:\Windows\Logs\magspoof_flipper_cardorganizer

.NOTES
  Version:        0.1
  Author:         FatherDivine & ChatGPT 3/5/2024
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
function Read-UserInput {
  begin {
      $userInput = @() # Initialize an array to hold user input
      $i = 1 # Used to track how many cards were inputted
  }

  process {
      Write-Verbose "Start scanning cards (Type 'Stop' to stop reading):" -Verbose

      do {
          $inputLine = Read-Host "Card$i"
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