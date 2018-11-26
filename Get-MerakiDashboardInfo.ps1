<#
.SYNOPSIS
  This script sets up your PowerShell window up for using other Meraki based functions.
  This is either meant to be imported or to be ran initially.
.DESCRIPTION
  This script pulls your organisation ID(s) and network ID(s) as well as your device details.
.PARAMETER apiKey
  From your Meraki dashboard, you'll need an API key to query dashboard. Please see Meraki documentation.
.INPUTS

.OUTPUTS

.NOTES
  Version:        1.0
  Author:         Karl Grindon
  Creation Date:  26th November 2018, in an Amsterdam hotel bar, enjoying Heineken.
  Purpose/Change: Initial version that actually works.
  
.EXAMPLE
  Open PowerShell, cd to the directory where the file is, run it with -apiKey as a parameter.
#>

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
    Write-Host "`nMeraki Org ID is: $($orgID.id)"
}

catch {
    Write-Host "Unable to get org ID"
}

try {

    $networkID = @()
    foreach ($organization in $orgID.id) {
            $networkID += Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/organizations/$($organization)/networks" -Headers $headers
    }

    Write-Host "`nMeraki network ID<s> are: $($networkID.id)"
}

catch {
    Write-Host "Unable to get network ID<s>"
}

try {
    
    $devices = @()

    foreach ($network in $networkID.id) {

        $devices += Invoke-RestMethod -Method GET -Uri "$merakiUrlPrefix/networks/$network/devices" -Headers $headers
    
    }
    
    Write-Host "`nWe found $($devices.Count) devices.`n"

}

catch {
    Write-Host "Unable to get Meraki device information."
}

function Set-OrgSelection {

    try {

        $menu = @{}
        for ($i=1;$i -le $orgID.count; $i++) {
            Write-Host "$i. $($orgID[$i-1].name),$($orgID[$i-1].id)" 
        $menu.Add($i,($orgID[$i-1].id))}

        [int]$orgChoiceAnswer = Read-Host "`nPlease enter the number corresponding to your desired org ID"
        $orgAnswer = $menu.Item($orgChoiceAnswer)

        echo "`nYou selected $($orgID.Name[$orgChoiceAnswer])"

        }
    
    catch {

        $errorMessage = $_.Exception.Message
        $errorItem = $_.Exception.Item

        throw "$errorMessage`n
        $errorItem"

    }
    

}

Set-OrgSelection