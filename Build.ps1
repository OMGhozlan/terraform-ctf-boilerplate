# Terraform CTF Challenge - Build Script (PowerShell)

param(
    [Parameter(Position=0)]
    [ValidateSet('help', 'init', 'validate', 'fmt', 'plan', 'apply', 'destroy', 'clean', 'status', 'progress', 'flags')]
    [string]$Command = 'help'
)

function Show-Help {
    Write-Host "Terraform CTF Challenge - Available Commands" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Setup:" -ForegroundColor Yellow
    Write-Host "  .\Build.ps1 init      - Initialize Terraform"
    Write-Host ""
    Write-Host "Development:" -ForegroundColor Yellow
    Write-Host "  .\Build.ps1 validate  - Validate and format code"
    Write-Host "  .\Build.ps1 fmt       - Format Terraform files"
    Write-Host "  .\Build.ps1 plan      - Show execution plan"
    Write-Host "  .\Build.ps1 apply     - Apply your solutions"
    Write-Host ""
    Write-Host "Progress:" -ForegroundColor Yellow
    Write-Host "  .\Build.ps1 status    - Show challenge status"
    Write-Host "  .\Build.ps1 progress  - Show progress"
    Write-Host "  .\Build.ps1 flags     - Show captured flags"
    Write-Host ""
    Write-Host "Cleanup:" -ForegroundColor Yellow
    Write-Host "  .\Build.ps1 clean     - Remove Terraform files"
    Write-Host "  .\Build.ps1 destroy   - Destroy all resources"
    Write-Host ""
}

switch ($Command) {
    'help' {
        Show-Help
    }
    'init' {
        Write-Host "Initializing Terraform..." -ForegroundColor Green
        terraform init
    }
    'validate' {
        Write-Host "Validating configuration..." -ForegroundColor Green
        terraform fmt -recursive
        terraform validate
    }
    'fmt' {
        terraform fmt -recursive
    }
    'plan' {
        terraform plan
    }
    'apply' {
        terraform apply
    }
    'destroy' {
        terraform destroy
    }
    'clean' {
        Write-Host "Cleaning Terraform files..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue .terraform
        Remove-Item -Force -ErrorAction SilentlyContinue .terraform.lock.hcl
        Remove-Item -Force -ErrorAction SilentlyContinue terraform.tfstate*
        Write-Host "Clean complete" -ForegroundColor Green
    }
    'status' {
        Write-Host "Challenge Status:" -ForegroundColor Cyan
        Write-Host "================" -ForegroundColor Cyan
        terraform output -json getting_started 2>$null
    }
    'progress' {
        terraform output completion_percentage 2>$null
    }
    'flags' {
        Write-Host "🏴 Captured Flags:" -ForegroundColor Cyan
        Write-Host "==================" -ForegroundColor Cyan
        terraform output -json captured_flags 2>$null | ConvertFrom-Json | ConvertTo-Json
    }
    default {
        Show-Help
    }
}