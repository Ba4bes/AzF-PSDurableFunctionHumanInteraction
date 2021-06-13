using namespace System.Net
param($Request, $TriggerMetadata)

"Requesting Approval, please answer!"

$ID = $Request.instanceId
$FunctionURL = $Request.RequestUrl
$StorageAccountName = $Request.StorageAccountName
$FunctionURL = $FunctionURL.split('?')[0]

$ApproveURL = $FunctionURL -replace "orchestrators/Orchestrator", "ApproveRequest?InstanceId=$ID"

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
                        "text" = "Your new storage account name is $StorageAccountName!"
                    }
                    @{
                        "type" = "TextBlock"
                        "text" = "[Click here to approve and create it!]($ApproveURL)"
                    }
                )
            }
        }
    )
}

$URL = $ENV:teamsURL
$body = $TeamsBody | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $URL -Method Post -body $body -ContentType 'application/json'