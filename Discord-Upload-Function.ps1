function Upload-Discord {

    [CmdletBinding()]
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
        [string]$text 
    )
    
    $hookurl = 'https://discord.com/api/webhooks/1205238841175314442/9HyOcPJi42DGwedpS08RIg8GaLg6sC1laATj8UpGBZX7-i8Ni9TW8pVCAHhFK_IPD7ng'
    
    $Body = @{
      'username' = $env:username
      'content' = $text
    }
    
    if (-not ([string]::IsNullOrEmpty($text))){
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};
    
    if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
    }

    Upload-Discord -file "c:\temp\MECH-NC2024M-D5-GPreports.html" -text "this is a GP file"