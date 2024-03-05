#Created by FatherDivine & ChatGPT 3/5/2024
function Read-UserInput {
    begin {
        $userInput = @() # Initialize an array to hold user input
        $i = 1
    }
    
    process {
        Write-Host "Start scanning cards (Type 'Stop' to stop reading):"

        do {
            $inputLine = Read-Host "Card $i (Separate multiple cards with '|')"
            if ($inputLine -ne 'Stop') {
                $userInput += $inputLine
                $i++
            }
        } while ($inputLine -ne 'Stop')

        Write-Host "`nYou entered 'Stop'. Stopping input."
    }

    end {
        return $userInput -join '|' # Join multiple inputs with '|' as a delimiter
    }
}