<#
	.SYNOPSIS
	Create a new Azure Resource Group.

	.DESCRIPTION
	Creates a new Azure Resource Group with the given credentials
	
	.PARAMETER SpId
	The Service principal client id

	.PARAMETER SpSecret
	The Service principal secret

	.PARAMETER SubscriptionId
	The subscription id

	.PARAMETER TenantId
	The tenant id

	.PARAMETER ResourceGroupName
	The name of the resource group to be created

    .PARAMETER ResourceGroupLocation
	The location of the resource group to be created ( e.g. "westeurope")
#>

param(		
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
    [Parameter(Mandatory = $True)]
	[string]$ResourceGroupLocation
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

Write-Host "==========================================="
Write-Host "		Creating the resource group "
Write-Host " Name:      $ResourceGroupName"
Write-Host " Location:  $ResourceGroupLocation"
Write-Host "==========================================="

az group create -l $ResourceGroupLocation -n $ResourceGroupName

if ($LastExitCode -ne 0) {
	throw "az group create failed!"
}

az logout --only-show-errors
