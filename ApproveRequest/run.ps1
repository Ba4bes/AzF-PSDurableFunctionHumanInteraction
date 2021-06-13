using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
# $Request
$ID = $Request.Query.InstanceId

$FunctionURL = $TriggerMetadata.Request.Url
$FunctionURL = $FunctionURL.split('/api')[0]
$URL = $FunctionURL + "/runtime/webhooks/durabletask/instances/$($ID)/raiseEvent/ApprovalEvent?code=" + $Env:key

Invoke-RestMethod $URL -Method Post -ContentType 'application/json' -Body '{}'



$Return = "Yes, we will create the storage account!!"

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $Return
    })