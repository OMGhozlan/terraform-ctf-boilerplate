Write-Host "🎯 Terraform CTF Challenge" -ForegroundColor Cyan
Write-Host ""

$stateExists = Test-Path "terraform.tfstate"

if (-not $stateExists) {
    Write-Host "Getting started:" -ForegroundColor Yellow
    Write-Host "  1. Copy terraform.tfvars.example to terraform.tfvars" -ForegroundColor Gray
    Write-Host "  2. Edit your player_name" -ForegroundColor Gray
    Write-Host "  3. Run: terraform init" -ForegroundColor Gray
    Write-Host "  4. Run: terraform apply" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "Quick commands:" -ForegroundColor Cyan
    Write-Host "  terraform output completion_percentage   - View progress" -ForegroundColor Gray
    Write-Host "  terraform output getting_started         - Getting started guide" -ForegroundColor Gray
    Write-Host "  terraform output -json captured_flags    - View captured flags" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  .\Build.ps1 flags                        - Show all flags" -ForegroundColor Gray
    Write-Host "  .\scripts\status-detailed.ps1            - Detailed status" -ForegroundColor Gray
    Write-Host ""
}