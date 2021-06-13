using namespace System.Net

# Input bindings are passed in via param block.
param($name, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Source for the wordlists: https://gist.github.com/hugsy/
$adjectives = invoke-restmethod "https://gist.githubusercontent.com/Ba4bes/5535cbdcc4d1dbccd561a96f1ed98795/raw/eec99c5597a73f6a9240cab26965a8609fa0f6ea/english-adjectives.txt"
$words = invoke-restmethod "https://gist.githubusercontent.com/Ba4bes/5535cbdcc4d1dbccd561a96f1ed98795/raw/eec99c5597a73f6a9240cab26965a8609fa0f6ea/english-nouns.txt"
$adjectivesArray = $adjectives -Split '\r?\n'.Trim()
$wordsarray = $words -Split '\r?\n'.Trim()

do {
    # Select an Adjective and a noun
    $Adjective = Get-Random -InputObject $adjectivesArray
    $allowedlength = 24 - $Adjective.Length
    $wordsallowed = $wordsarray | Where-Object { $_.length -le $allowedlength }
    $word = Get-Random -InputObject $wordsallowed
    $result = $adjective + $word
    Write-Host "result: $Result"
    #Check availability
    $availability = Get-AzStorageAccountNameAvailability -Name $result
} while ($availability.NameAvailable -eq $false)

$Result
