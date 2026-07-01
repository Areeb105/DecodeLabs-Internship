param(
  [Parameter(Mandatory = $true)]
  [string]$ResourceGroup,

  [Parameter(Mandatory = $true)]
  [string]$StorageAccount,

  [string]$Location = "centralindia"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
  throw "Azure CLI was not found. Install it and run 'az login' first."
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

az group create --name $ResourceGroup --location $Location | Out-Null
az storage account create `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --location $Location `
  --sku Standard_LRS `
  --kind StorageV2 | Out-Null

az storage blob service-properties update `
  --account-name $StorageAccount `
  --static-website `
  --index-document index.html `
  --404-document index.html | Out-Null

az storage blob upload `
  --account-name $StorageAccount `
  --container-name '$web' `
  --name index.html `
  --file (Join-Path $root "index.html") `
  --content-type "text/html" `
  --overwrite | Out-Null

az storage blob upload `
  --account-name $StorageAccount `
  --container-name '$web' `
  --name styles.css `
  --file (Join-Path $root "styles.css") `
  --content-type "text/css" `
  --overwrite | Out-Null

$endpoint = az storage account show `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --query "primaryEndpoints.web" `
  --output tsv

Write-Host "Deployment complete:"
Write-Host $endpoint
