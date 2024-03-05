function Read-UserInput {
    begin {
        # Initialization code can go here
        $userInput = @() # Initialize an array to hold user input
        #Our incrementer
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

            # Add processing logic here for $userInput
            Write-Verbose "Here's the userinput: $userInput" -Verbose
        
        else {
            # Logic to handle file input goes here
        }
    }

    end {
        # Any cleanup or final processing can go here
        # For example, processing the collected $userInput
    }
}
#export-modulemember -alias * -function *