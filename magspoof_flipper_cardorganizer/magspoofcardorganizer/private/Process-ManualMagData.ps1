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
function Process-ManualMagData {
    param(
        [string]$CardInfo,
        [string]$OutputDirectory,
        [string]$MagFileHeader
    )

    # Check if the output directory exists; if not, create it
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -Path $OutputDirectory -ItemType Directory -Force
    }
    
    # Split the input into individual cards using the '|' delimiter
    $cards = $CardInfo -split '\|'
    $cardIndex = 1

    foreach ($card in $cards) {
        # Initialize for each card
        $tn = 1
        $processedTracks = @()

        # Split the current card by semicolons to identify the tracks
        $tracks = $card -split ';'
        foreach ($track in $tracks) {
            if (-not [string]::IsNullOrWhiteSpace($track)) {
                $processedTracks += "Track $tn`: ;$track"
                $tn++
            }
        }

        # Combine header and tracks for the current card
        $output = $MagFileHeader + $processedTracks -join "`n"
        
        # Define and write the output for the current card to a .mag file
        $fileName = "Card$cardIndex.mag"
        $filePath = Join-Path -Path $OutputDirectory -ChildPath $fileName
        $output | Set-Content -Path $filePath -Force

        Write-Verbose "Generated file: $filePath" -Verbose
        $cardIndex++
    }
}