param(
  [Parameter(Mandatory = $true)]
  [string]$BucketName,

  [string]$Region = "ap-south-1"
)

$ErrorActionPreference = "Stop"

function Invoke-Aws {
  py -3.12 -m awscli @args
}

try {
  Invoke-Aws --version | Out-Null
} catch {
  throw "AWS CLI was not found for Python 3.12. Install it with: py -3.12 -m pip install awscli"
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$policyPath = Join-Path $root "aws-bucket-policy.generated.json"
$websiteConfigPath = Join-Path $root "aws-website-config.generated.json"

@{
  IndexDocument = @{ Suffix = "index.html" }
  ErrorDocument = @{ Key = "index.html" }
} | ConvertTo-Json -Depth 5 | Set-Content -Path $websiteConfigPath -Encoding utf8

(Get-Content -Path (Join-Path $root "aws-bucket-policy.json") -Raw).Replace("YOUR_BUCKET_NAME", $BucketName) |
  Set-Content -Path $policyPath -Encoding utf8

if ($Region -eq "us-east-1") {
  Invoke-Aws s3api create-bucket --bucket $BucketName | Out-Null
} else {
  Invoke-Aws s3api create-bucket --bucket $BucketName --region $Region --create-bucket-configuration LocationConstraint=$Region | Out-Null
}

Invoke-Aws s3api put-public-access-block `
  --bucket $BucketName `
  --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false | Out-Null

Invoke-Aws s3api put-bucket-website --bucket $BucketName --website-configuration file://$websiteConfigPath | Out-Null
Invoke-Aws s3api put-bucket-policy --bucket $BucketName --policy file://$policyPath | Out-Null

Invoke-Aws s3 cp (Join-Path $root "index.html") "s3://$BucketName/index.html" --content-type "text/html" | Out-Null
Invoke-Aws s3 cp (Join-Path $root "styles.css") "s3://$BucketName/styles.css" --content-type "text/css" | Out-Null

$endpoint = "http://$BucketName.s3-website.$Region.amazonaws.com"
Write-Host "Deployment complete:"
Write-Host $endpoint
