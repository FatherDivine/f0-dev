<#
.SYNOPSIS
  Processes magstrip data.

.DESCRIPTION
  This module/script processes the data generated
  from magstrip cards. It's meant to process a file
  that's saved in any format (I like .dump) using a
  "USB emulation keyboard interface" magstrip reader
  like the MSR90 USB magnetic cc reader.

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
  Process-MagData -FileName "C:\path\to\your\file.txt" -OutputDirectory "C:\temp\mags\manual" -MagFileHeader $MagFileHeader

  Processes a file named file.txt and outputs the individual cards to c:\temp\mags\manual using the $MagFileHeader
  which is the top lines of the .mag files.
#>

function Process-MagData {
  [cmdletbinding()]
  param(
    [string]$FileName,
    [string]$OutputDirectory,
    [string]$MagFileHeader
  )

    # Ensure the output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -Path $OutputDirectory -ItemType Directory -Force
    }
    # Initialize counter for file naming
    $i = 0

    # Process each line (assumed each line is a separate card) from the file
    $cards = Get-Content $FileName
    foreach ($card in $cards) {
        if ($card -notmatch "^#") {
            $i++
            $filePath = Join-Path -Path $OutputDirectory -ChildPath "mag$i.mag"

            # Split card data into tracks based on ';' with a preceding character
            $tracks = $card -split '(?<!^)(?<=.);'
            $processedTracks = @("$MagFileHeader") # Start with header
            $tn = 1

            foreach ($track in $tracks) {
                if (-not [string]::IsNullOrWhiteSpace($track)) {
                    # Append each track to processedTracks
                    $processedTracks += "Track $tn`: ;$track"
                    $tn++
                }
            }

            # Combine processed tracks into single content string and write to file
            $fileContent = $processedTracks -join "`n"
            Set-Content -Path $filePath -Value $fileContent -Force
        }
    }

    Write-Verbose "$i .mag files were processed and written to $OutputDirectory." -Verbose
}