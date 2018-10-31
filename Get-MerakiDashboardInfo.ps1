param (
    [Parameter(Mandatory = $true)]
    [string] $apiKey
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$merakiUrlPrefix = 'https://api.meraki.com/api/v0'
$headers = @{
    "X-Cisco-Meraki-API-KEY" = $apiKey
    "Content-Type" = 'application/json'
}

cls

try {
    $orgID = Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/organizations" -Headers $headers
    Write-Host "Meraki Org ID is: $($orgID.id)"
}

catch {
    Write-Host "Unable to get org ID"
}

try {
    $networkID = Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/organizations/$($orgID.id)/networks" -Headers $headers
    Write-Host "Meraki network ID<s> are: $($networkID.id)"
}

catch {
    Write-Host "Unable to get network ID<s>"
}

try {
    
    $devices = @()

    foreach ($network in $networkID.id) {

        $devices += Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/networks/$network/devices" -Headers $headers
    
    }
    
    Write-Host "Meraki device information found."
}

catch {
    Write-Host "Unable to get Meraki device information."
}
