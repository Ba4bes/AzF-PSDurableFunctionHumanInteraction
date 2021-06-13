param($Request)

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
                        "text" = "You took to long. No storage account has been created"
                    }
                )
            }
        }
    )
}

$URL = $ENV:teamsURL
$body = $TeamsBody | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $URL -Method Post -body $body -ContentType 'application/json'