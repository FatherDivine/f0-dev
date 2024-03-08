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
function Process-ManualMagData {
  [cmdletbinding()]
  param(
      [string]$CardInfo,
      [string]$OutputDirectory,
      [string]$MagFileHeader
  )

  if (-not (Test-Path -Path $OutputDirectory)) {
      New-Item -Path $OutputDirectory -ItemType Directory -Force
  }

  $cards = $CardInfo -split '\|'
  $cardIndex = 1

  foreach ($card in $cards) {
      if (-not [string]::IsNullOrWhiteSpace($card)) {
          $tn = 1
          $processedTracks = @()
          $tracks = $card -split ';'
          foreach ($track in $tracks) {
              if (-not [string]::IsNullOrWhiteSpace($track)) {
                  # Note: Removed the newline character from the start of each track line
                  $processedTracks += "Track $tn`: ;$track"
                  $tn++
              }
          }

          # Only proceed if there are processed tracks to avoid creating empty files
          if ($processedTracks.Count -gt 0) {
              # Now, we explicitly add a newline character after the header and before the first track
              # Ensure the header itself ends with a newline to avoid starting the first track on the same line
              $output = $MagFileHeader.TrimEnd() + "`n" + ($processedTracks -join "`n").Trim()

              $fileName = "Card$cardIndex.mag"
              $filePath = Join-Path -Path $OutputDirectory -ChildPath $fileName
              Set-Content -Path $filePath -Value $output -Force

              Write-Verbose "Generated file: $filePath" -Verbose
              $cardIndex++
          }
      }
  }
}