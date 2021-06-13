param($Context, $TriggerMetadata)

$StorageAccountName = Invoke-ActivityFunction -FunctionName 'GetStorageAccountName'
"New StorageAccount Name: $StorageAccountName"

$instanceId = $TriggerMetadata.Context.instanceId

$duration = New-TimeSpan -Seconds 300
$Object = [PSCustomObject]@{
    storageAccountName = $StorageAccountName
    instanceID         = $instanceId
    RequestUrl         = $Context.Input
}
Invoke-DurableActivity -FunctionName "RequestApproval" -Input $Object

$durableTimeoutEvent = Start-DurableTimer -Duration $duration -NoWait
$approvalEvent = Start-DurableExternalEventListener -EventName "ApprovalEvent" -NoWait

$firstEvent = Wait-DurableTask -Task @($approvalEvent, $durableTimeoutEvent) -Any

if ($approvalEvent -eq $firstEvent) {
    Stop-DurableTimerTask -Task $durableTimeoutEvent
    Invoke-DurableActivity -FunctionName "NewStorageAccount" -Input $StorageAccountName
}
else {
    Invoke-DurableActivity -FunctionName "EscalateApproval"
}
