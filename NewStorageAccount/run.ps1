using namespace System.Net

# Input bindings are passed in via param block.
param($name, $TriggerMetadata)
Write-Host "Creating Storage Account"
Try {
    $SAResult = New-AzStorageAccount -Name $name -ResourceGroupName 'Durable' -Location 'West Europe' -SkuName Standard_LRS  -ErrorAction Stop
    Write-Host "StorageAccount created"
    $SAResult
}
Catch {
    Write-Host "ERROR, could not create storage account: $_"
}

$TeamsBody = @{
    "type"        = "message"
    "attachments" = @(
        @{
            "contentType" = "application/vnd.microsoft.card.adaptive"
            "contentUrl"  = $null
            "content"     = @{
                "$schema" = "http://adaptivecards.io/schemas/adaptive-card.json"
                "type"    = "AdaptiveCard"
                "version" = "1.2"
                "body"    = @(
                    @{
                        "type" = "TextBlock"
                        "text" = "Your new storage account $name has been created!"
                    }
                    @{
                        "type" = "TextBlock"
                        "text" = "$SAResult"
                    }
                )
            }
        }
    )
}

$URL = $ENV:teamsURL
$body = $TeamsBody | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $URL -Method Post -body $body -ContentType 'application/json'