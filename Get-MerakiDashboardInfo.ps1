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
if ($merakiOrganization = (Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/organizations" -Headers $headers) | Select -ExpandProperty id) {

    Write-Host "Meraki Org ID info found"

} else {

    Write-Host "Unable to find Meraki org data"

}

if ($merakiNetworks = Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/organizations/$merakiOrganization/networks" -Headers $headers | foreach ($_) {Select $_.id}) {

    Write-Host "Meraki network ID(s) info found."

} else {

    Write-Host "Unable to find Meraki network data"

}