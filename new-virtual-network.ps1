<#
    .SYNOPSIS
    Creates a virtual network

    .DESCRIPTION
    Creates a virtual network

    .PARAMETER SpId
	  The Service principal client id.
	
    .PARAMETER SpSecret
	  The Service principal secret.
	
    .PARAMETER SubscriptionId
	  The subscription id.
	
    .PARAMETER TenantId
	  The tenant id.
	
    .PARAMETER ResourceGroupName
	  The name of the resource group in which to create the virtual network.

    .PARAMETER AddressPrefixes
    Space-separated list of IP address prefixes for the VNet. Default value: 10.0.0.0/16.

    .PARAMETER Name
	  The name of the virtual network.

    .PARAMETER SubnetName
	  Name of a new subnet to create within the VNet.

    .PARAMETER SubnetPrefixes
	  Space-separated list of address prefixes in CIDR format for the new subnet. 
    If omitted, automatically reserves a /24 (or as large as available) block within 
    the VNet address space.
    
#>

param (
    [Parameter(Mandatory = $True)]
	  [string]$SpId,
	  [Parameter(Mandatory = $True)]
	  [string]$SpSecret,
	  [Parameter(Mandatory = $True)]
	  [string]$SubscriptionId,
	  [Parameter(Mandatory = $True)]
	  [string]$TenantId,
	  [Parameter(Mandatory = $True)]
	  [string]$ResourceGroupName,
    [Parameter(Mandatory = $False)]
    [string]$AddressPrefixes = "10.0.0.0/16",
    [Parameter(Mandatory = $True)]
    [string]$Name,
    [Parameter(Mandatory = $True)]
    [string]$SubnetName,
    [Parameter(Mandatory = $True)]
    [string]$SubnetPrefixes
)

Write-Host "==================================="
Write-Host "		Logging in to Azure"
Write-Host "==================================="

az login --service-principal -u $SpId -p $SpSecret --tenant $TenantId
if ($LastExitCode -ne 0) {
	throw "az login failed!"
}

az account set --subscription $SubscriptionId
if ($LastExitCode -ne 0) {
	throw "az set --subscription failed!"
}

Write-Host "============================================"
Write-Host "		Creating the virtual network "
Write-Host "============================================"

az network vnet create `
--address-prefixes $AddressPrefixes `
--name $Name `
--resource-group $ResourceGroupName `
--subnet-name $SubnetName `
--subnet-prefixes $SubnetPrefixes

if ($LastExitCode -ne 0) {
	throw "az network vnet create failed!"
}

az logout --only-show-errors
