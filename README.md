# Decode Labs Cloud Computing Project 1

Project: **The Global Launch**

This repository contains a complete static portfolio website prepared for cloud object-storage hosting. It satisfies the project mission:

- Create an HTML/CSS portfolio.
- Upload the static files to AWS S3 or Azure Blob Storage.
- Enable static website hosting.
- Configure public access.
- Share the live website URL.

## Live Website

AWS S3 static website URL:

```text
http://areeb-portfolio-2026-786.s3-website.ap-south-1.amazonaws.com
```

## Files

- `index.html` - portfolio page
- `styles.css` - responsive styling
- `aws-bucket-policy.json` - AWS public-read bucket policy template
- `deploy-aws-s3.ps1` - AWS CLI deployment helper
- `deploy-azure-blob.ps1` - Azure CLI deployment helper

## Customize Before Submission

Open `index.html` and replace:

- `your.email@example.com`
- LinkedIn URL
- GitHub URL
- Any text that should use your real name, skills, or projects

## Deploy With AWS S3

Prerequisites:

- AWS account
- AWS CLI installed
- AWS CLI configured with `aws configure`

Run:

```powershell
.\deploy-aws-s3.ps1 -BucketName "your-unique-bucket-name" -Region "ap-south-1"
```

The script creates the bucket, enables static website hosting, applies the public-read policy, uploads the files, and prints the website endpoint.

Manual AWS steps:

1. Create an S3 bucket with a globally unique name.
2. Disable "Block all public access" for this bucket.
3. Enable static website hosting.
4. Set index document to `index.html`.
5. Apply the policy from `aws-bucket-policy.json` after replacing `YOUR_BUCKET_NAME`.
6. Upload `index.html` and `styles.css`.
7. Open the S3 static website endpoint.

## Deploy With Azure Blob Storage

Prerequisites:

- Azure account
- Azure CLI installed
- Logged in with `az login`

Run:

```powershell
.\deploy-azure-blob.ps1 -ResourceGroup "decode-labs-rg" -StorageAccount "youruniquestorageacct" -Location "centralindia"
```

The script creates a resource group, creates a storage account, enables static website hosting, uploads the files to `$web`, and prints the website endpoint.

## Submission Checklist

- [ ] Website opens locally.
- [ ] Name, email, and profile links are customized.
- [ ] Static hosting enabled on AWS S3 or Azure Blob Storage.
- [ ] Public URL opens in a browser.
- [ ] Screenshot of bucket/container settings saved if required by mentor.
- [ ] Live URL submitted to Decode Labs.
