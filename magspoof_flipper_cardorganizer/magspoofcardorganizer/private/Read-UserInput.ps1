#Created by FatherDivine & ChatGPT 3/5/2024
function Read-UserInput {
    begin {
        # Initialization code can go here
        $userInput = @() # Initialize an array to hold user input
        #Incrementer to keep track of what card # is being processed
        $i = 1
    }
    
    process {
            Write-Host "Start scanning cards (Type 'Stop' and enter key to stop reading):"

            do {
                $inputLine = Read-Host "Card $i"
                if ($inputLine -ne 'Stop') {
                    $userInput += $inputLine
                } $i++
            } while ($inputLine -ne 'Stop')

            Write-Host "`nYou entered 'Stop'. Stopping input."       
        else {
            # Logic to handle file input goes here
        }
    }

    end {
        # Any cleanup or final processing can go here
        # For example, processing the collected $userInput
        #This line allows the data to be sent back to the original script
        #as long as the call to this function is within a variable: "$TestVar = Read-UserInput"
        return $userInput
    }
}