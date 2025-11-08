<#
.SYNOPSIS
    Safe, interactive installer for Terraform, VS Code, and extensions.

.DESCRIPTION
    This script installs development tools with user confirmation at each step:
    - HashiCorp Terraform (to user's home directory - no admin needed)
    - Visual Studio Code (user or system install)
    - VS Code Extensions: Terraform & GitLens

    Shows all download sources FIRST before any installation.

.PARAMETER NonInteractive
    Skip all prompts and use defaults (for automation)

.PARAMETER InstallPath
    Custom installation path for Terraform (default: ~\.terraform\bin)

.PARAMETER ShowLinksOnly
    Display download links and exit (no installation)

.EXAMPLE
    .\Install-CTFTools.ps1

.EXAMPLE
    .\Install-CTFTools.ps1 -ShowLinksOnly

.EXAMPLE
    .\Install-CTFTools.ps1 -InstallPath "C:\MyTools\Terraform"

.NOTES
    Author: Terraform CTF Challenge
    Version: 2.1.0
    No Administrator privileges required for basic installation
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$InstallPath,

    [Parameter(Mandatory=$false)]
    [switch]$NonInteractive,

    [Parameter(Mandatory=$false)]
    [switch]$ShowLinksOnly
)

# ============================================================================
# Configuration
# ============================================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"  # Faster downloads

# Default to user's home directory if not specified
if (-not $InstallPath) {
    $InstallPath = Join-Path $env:USERPROFILE ".terraform\bin"
}

$Config = @{
    TerraformAPIUrl     = "https://api.releases.hashicorp.com/v1/releases/terraform/latest"
    TerraformDownload   = "https://developer.hashicorp.com/terraform/downloads"
    VSCodeUserUrl       = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    VSCodeSystemUrl     = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
    VSCodeDownload      = "https://code.visualstudio.com/download"
    TempPath            = Join-Path $env:TEMP "TerraformSetup"
    TerraformPath       = $InstallPath
    Extensions          = @(
        @{
            Id          = "hashicorp.terraform"
            Name        = "Terraform"
            Description = "Syntax highlighting, IntelliSense, and formatting for Terraform"
            URL         = "https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform"
        },
        @{
            Id          = "eamodio.gitlens"
            Name        = "GitLens"
            Description = "Git visualization and code authorship"
            URL         = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens"
        }
    )
}

# ============================================================================
# Helper Functions
# ============================================================================

function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error', 'Header', 'Question')]
        [string]$Type = 'Info'
    )

    $colors = @{
        'Info'     = 'Cyan'
        'Success'  = 'Green'
        'Warning'  = 'Yellow'
        'Error'    = 'Red'
        'Header'   = 'Magenta'
        'Question' = 'White'
    }

    $symbols = @{
        'Info'     = 'ℹ️ '
        'Success'  = '✅'
        'Warning'  = '⚠️ '
        'Error'    = '❌'
        'Header'   = '🚀'
        'Question' = '❓'
    }

    Write-Host "$($symbols[$Type]) $Message" -ForegroundColor $colors[$Type]
}

function Write-SectionHeader {
    param([string]$Title)

    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host " $Title" -ForegroundColor Magenta
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host ""
}

function Write-Explanation {
    param([string]$Text)
    Write-Host "  📝 " -ForegroundColor Gray -NoNewline
    Write-Host $Text -ForegroundColor Gray
}

function Write-ResourceBox {
    param(
        [string]$Title,
        [string]$Description,
        [string]$URL,
        [string]$Size,
        [string]$Type
    )

    # Calculate required width dynamically based on content
    $minWidth = 75
    $titleWidth = $Title.Length + 3
    $descWidth = "Description: ".Length + $Description.Length + 3
    $typeWidth = if ($Type) { "Type: ".Length + $Type.Length + 3 } else { 0 }
    $sizeWidth = if ($Size) { "Size: ".Length + $Size.Length + 3 } else { 0 }
    $urlWidth = "Download: ".Length + $URL.Length + 3

    $width = [Math]::Max($minWidth, [Math]::Max($titleWidth, [Math]::Max($descWidth, [Math]::Max($typeWidth, [Math]::Max($sizeWidth, $urlWidth)))))
    
    # Cap at reasonable maximum
    $maxWidth = 120
    if ($width -gt $maxWidth) {
        $width = $maxWidth
        $urlNeedsTruncation = $true
    } else {
        $urlNeedsTruncation = $false
    }

    Write-Host "┌" -ForegroundColor Cyan -NoNewline
    Write-Host ("─" * ($width - 2)) -ForegroundColor Cyan -NoNewline
    Write-Host "┐" -ForegroundColor Cyan

    # Title
    Write-Host "│ " -ForegroundColor Cyan -NoNewline
    Write-Host $Title -ForegroundColor White -NoNewline
    $padding = $width - $Title.Length - 3
    if ($padding -gt 0) {
        Write-Host (" " * $padding) -NoNewline
    }
    Write-Host "│" -ForegroundColor Cyan

    # Separator
    Write-Host "│" -ForegroundColor Cyan -NoNewline
    Write-Host ("─" * ($width - 2)) -ForegroundColor DarkGray -NoNewline
    Write-Host "│" -ForegroundColor Cyan

    # Description
    Write-Host "│ " -ForegroundColor Cyan -NoNewline
    Write-Host "Description: " -ForegroundColor Gray -NoNewline
    Write-Host $Description -ForegroundColor White -NoNewline
    $padding = $width - ("Description: ".Length + $Description.Length + 3)
    if ($padding -gt 0) {
        Write-Host (" " * $padding) -NoNewline
    }
    Write-Host "│" -ForegroundColor Cyan

    # Type
    if ($Type) {
        Write-Host "│ " -ForegroundColor Cyan -NoNewline
        Write-Host "Type: " -ForegroundColor Gray -NoNewline
        Write-Host $Type -ForegroundColor Yellow -NoNewline
        $padding = $width - ("Type: ".Length + $Type.Length + 3)
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host "│" -ForegroundColor Cyan
    }

    # Size
    if ($Size) {
        Write-Host "│ " -ForegroundColor Cyan -NoNewline
        Write-Host "Size: " -ForegroundColor Gray -NoNewline
        Write-Host $Size -ForegroundColor Yellow -NoNewline
        $padding = $width - ("Size: ".Length + $Size.Length + 3)
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host "│" -ForegroundColor Cyan
    }

    # URL (with truncation if needed)
    Write-Host "│ " -ForegroundColor Cyan -NoNewline
    Write-Host "Download: " -ForegroundColor Gray -NoNewline
    
    if ($urlNeedsTruncation) {
        $maxUrlLen = $width - "Download: ".Length - 6  # Leave room for "..." and borders
        if ($URL.Length -gt $maxUrlLen) {
            $truncatedUrl = $URL.Substring(0, $maxUrlLen) + "..."
            Write-Host $truncatedUrl -ForegroundColor Blue -NoNewline
            $padding = $width - ("Download: ".Length + $truncatedUrl.Length + 3)
        } else {
            Write-Host $URL -ForegroundColor Blue -NoNewline
            $padding = $width - ("Download: ".Length + $URL.Length + 3)
        }
    } else {
        Write-Host $URL -ForegroundColor Blue -NoNewline
        $padding = $width - ("Download: ".Length + $URL.Length + 3)
    }
    
    if ($padding -gt 0) {
        Write-Host (" " * $padding) -NoNewline
    }
    Write-Host "│" -ForegroundColor Cyan

    # Bottom
    Write-Host "└" -ForegroundColor Cyan -NoNewline
    Write-Host ("─" * ($width - 2)) -ForegroundColor Cyan -NoNewline
    Write-Host "┘" -ForegroundColor Cyan
}

function Show-ResourceLinks {
    Clear-Host

    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║                                                                       ║" -ForegroundColor Magenta
    Write-Host "║           📦 REQUIRED RESOURCES & DOWNLOAD LINKS                     ║" -ForegroundColor Magenta
    Write-Host "║                                                                       ║" -ForegroundColor Magenta
    Write-Host "╚═══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""

    Write-ColorOutput "This script will download and install the following resources:" -Type Info
    Write-Host ""
    Write-Host "All downloads are from official sources only. You can verify these links" -ForegroundColor Gray
    Write-Host "or download manually if you prefer." -ForegroundColor Gray
    Write-Host ""

    # Get Terraform version info
    Write-Host "Fetching latest version information..." -ForegroundColor Gray
    try {
        $tfInfo = Get-LatestTerraformVersion
        $tfVersion = $tfInfo.Version
        $tfDownloadUrl = $tfInfo.DownloadUrl
        $tfSize = "~40 MB"
    } catch {
        $tfVersion = "Latest"
        $tfDownloadUrl = $Config.TerraformDownload
        $tfSize = "~40 MB"
    }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""

    # 1. Terraform
    Write-Host "1️⃣  TERRAFORM CLI" -ForegroundColor Green
    Write-Host ""
    Write-ResourceBox `
        -Title "HashiCorp Terraform $tfVersion" `
        -Description "Infrastructure as Code tool" `
        -URL $tfDownloadUrl `
        -Size $tfSize `
        -Type "Executable (ZIP archive)"

    Write-Host ""
    Write-Host "   Official Page: " -ForegroundColor Gray -NoNewline
    Write-Host "https://developer.hashicorp.com/terraform/" -ForegroundColor Blue
    Write-Host "   Documentation: " -ForegroundColor Gray -NoNewline
    Write-Host "https://developer.hashicorp.com/terraform/docs" -ForegroundColor Blue
    Write-Host "   Learn: " -ForegroundColor Gray -NoNewline
    Write-Host "https://developer.hashicorp.com/terraform/tutorials" -ForegroundColor Blue

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""

    # 2. VS Code
    Write-Host "2️⃣  VISUAL STUDIO CODE" -ForegroundColor Green
    Write-Host ""
    Write-ResourceBox `
        -Title "Visual Studio Code (Latest Stable)" `
        -Description "Microsoft's free code editor" `
        -URL $Config.VSCodeDownload `
        -Size "~85 MB" `
        -Type "Installer (User or System)"

    Write-Host ""
    Write-Host "   User Installer: " -ForegroundColor Gray -NoNewline
    Write-Host $Config.VSCodeUserUrl -ForegroundColor Blue
    Write-Host "   System Installer: " -ForegroundColor Gray -NoNewline
    Write-Host $Config.VSCodeSystemUrl -ForegroundColor Blue
    Write-Host ""
    Write-Host "   Official Page: " -ForegroundColor Gray -NoNewline
    Write-Host "https://code.visualstudio.com/" -ForegroundColor Blue
    Write-Host "   Documentation: " -ForegroundColor Gray -NoNewline
    Write-Host "https://code.visualstudio.com/docs" -ForegroundColor Blue

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""

    # 3. Extensions
    Write-Host "3️⃣  VS CODE EXTENSIONS" -ForegroundColor Green
    Write-Host ""

    foreach ($ext in $Config.Extensions) {
        Write-ResourceBox `
            -Title $ext.Name `
            -Description $ext.Description `
            -URL $ext.URL `
            -Size "~5 MB" `
            -Type "VS Code Extension"

        Write-Host ""
        Write-Host "   Extension ID: " -ForegroundColor Gray -NoNewline
        Write-Host $ext.Id -ForegroundColor Yellow
        Write-Host "   Install via CLI: " -ForegroundColor Gray -NoNewline
        Write-Host "code --install-extension $($ext.Id)" -ForegroundColor Cyan
        Write-Host ""
    }

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""

    # Summary
    Write-Host "📊 TOTAL DOWNLOAD SIZE: ~130 MB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔒 SECURITY NOTES:" -ForegroundColor Yellow
    Write-Host "   ✓ All downloads are from official vendor websites" -ForegroundColor Green
    Write-Host "   ✓ Terraform: HashiCorp official releases" -ForegroundColor Green
    Write-Host "   ✓ VS Code: Microsoft official downloads" -ForegroundColor Green
    Write-Host "   ✓ Extensions: Official VS Code Marketplace" -ForegroundColor Green
    Write-Host ""

    Write-Host "💾 INSTALLATION LOCATIONS:" -ForegroundColor Yellow
    Write-Host "   • Terraform: " -ForegroundColor Gray -NoNewline
    Write-Host $InstallPath -ForegroundColor White
    Write-Host "   • VS Code: " -ForegroundColor Gray -NoNewline
    Write-Host "$env:LOCALAPPDATA\Programs\Microsoft VS Code (User Install)" -ForegroundColor White
    Write-Host "             or C:\Program Files\Microsoft VS Code (System Install)" -ForegroundColor Gray
    Write-Host "   • Temp files: " -ForegroundColor Gray -NoNewline
    Write-Host "$($Config.TempPath)" -ForegroundColor White
    Write-Host ""

    Write-Host "🔧 SYSTEM CHANGES:" -ForegroundColor Yellow
    Write-Host "   • Adds Terraform to User PATH (no admin required)" -ForegroundColor White
    Write-Host "   • Adds VS Code to PATH (for 'code' command)" -ForegroundColor White
    Write-Host "   • No system files modified (unless you choose system-wide install)" -ForegroundColor White
    Write-Host ""

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""
}

function Confirm-Action {
    param(
        [string]$Title,
        [string]$Description,
        [string[]]$Changes,
        [string]$DefaultChoice = "Y"
    )

    if ($NonInteractive) {
        return $true
    }

    Write-Host ""
    Write-Host "┌─────────────────────────────────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "│ " -ForegroundColor Yellow -NoNewline
    Write-Host "ACTION REQUIRED: $Title" -ForegroundColor White -NoNewline
    Write-Host (" " * (55 - $Title.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Yellow
    Write-Host "└─────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
    Write-Host ""

    Write-Explanation $Description
    Write-Host ""

    if ($Changes.Count -gt 0) {
        Write-Host "  This will:" -ForegroundColor Cyan
        foreach ($change in $Changes) {
            Write-Host "    • $change" -ForegroundColor White
        }
        Write-Host ""
    }

    $prompt = "  Do you want to proceed? (Y/n)"
    if ($DefaultChoice -eq "N") {
        $prompt = "  Do you want to proceed? (y/N)"
    }

    Write-Host $prompt -ForegroundColor Yellow -NoNewline
    Write-Host ": " -NoNewline

    $response = Read-Host

    if ($response -eq "") {
        $response = $DefaultChoice
    }

    return ($response -eq 'y' -or $response -eq 'Y')
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-SystemArchitecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if ($arch -eq "AMD64" -or $arch -eq "x64") {
        return "amd64"
    } elseif ($arch -eq "ARM64") {
        return "arm64"
    } else {
        return "386"
    }
}

function Add-ToUserPath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

        if ($currentPath -notlike "*$Path*") {
            # Explain what we're doing
            $confirmed = Confirm-Action `
                -Title "Update User PATH" `
                -Description "Add Terraform to your PATH so you can run 'terraform' from any location" `
                -Changes @(
                    "Add '$Path' to your User PATH environment variable",
                    "This only affects your user account (no admin required)",
                    "You'll need to restart your terminal for changes to take effect"
                )

            if (-not $confirmed) {
                Write-ColorOutput "Skipped PATH update. You'll need to use the full path to run Terraform." -Type Warning
                return $false
            }

            Write-ColorOutput "Adding to User PATH: $Path" -Type Info

            $newPath = if ($currentPath) { "$currentPath;$Path" } else { $Path }
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

            # Update current session
            $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                        [Environment]::GetEnvironmentVariable("Path", "User")

            Write-ColorOutput "User PATH updated successfully" -Type Success
            Write-ColorOutput "Restart your terminal for the changes to take effect" -Type Info
            return $true
        } else {
            Write-ColorOutput "Path already in User PATH" -Type Info
            return $true
        }
    } catch {
        Write-ColorOutput "Failed to update PATH: $_" -Type Error
        return $false
    }
}

function Add-ToSystemPath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Administrator)) {
        Write-ColorOutput "Cannot add to System PATH: Administrator privileges required" -Type Warning
        Write-ColorOutput "Added to User PATH instead (works for your account only)" -Type Info
        return Add-ToUserPath -Path $Path
    }

    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

        if ($currentPath -notlike "*$Path*") {
            # Explain what we're doing
            $confirmed = Confirm-Action `
                -Title "Update System PATH (Admin)" `
                -Description "Add Terraform to the system-wide PATH (affects all users on this computer)" `
                -Changes @(
                    "Add '$Path' to System PATH environment variable",
                    "All users on this computer will be able to use Terraform",
                    "Requires Administrator privileges",
                    "You'll need to restart terminals for changes to take effect"
                )

            if (-not $confirmed) {
                Write-ColorOutput "Skipped System PATH update." -Type Warning

                # Offer user PATH as alternative
                $userPathChoice = Confirm-Action `
                    -Title "Use User PATH Instead?" `
                    -Description "Add to your personal PATH instead (no admin needed)" `
                    -Changes @("Add to User PATH (only affects your account)")

                if ($userPathChoice) {
                    return Add-ToUserPath -Path $Path
                }
                return $false
            }

            Write-ColorOutput "Adding to System PATH: $Path" -Type Info

            $newPath = "$currentPath;$Path"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

            # Update current session
            $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                        [Environment]::GetEnvironmentVariable("Path", "User")

            Write-ColorOutput "System PATH updated successfully" -Type Success
            return $true
        } else {
            Write-ColorOutput "Path already in System PATH" -Type Info
            return $true
        }
    } catch {
        Write-ColorOutput "Failed to update System PATH: $_" -Type Error
        Write-ColorOutput "Trying User PATH instead..." -Type Warning
        return Add-ToUserPath -Path $Path
    }
}

function Test-CommandExists {
    param([string]$Command)

    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

function Get-LatestTerraformVersion {
    try {
        $response = Invoke-RestMethod -Uri $Config.TerraformAPIUrl -UseBasicParsing
        $version = $response.version
        $arch = Get-SystemArchitecture

        $downloadUrl = "https://releases.hashicorp.com/terraform/$version/terraform_${version}_windows_${arch}.zip"

        return @{
            Version     = $version
            DownloadUrl = $downloadUrl
            FileName    = "terraform_${version}_windows_${arch}.zip"
        }
    } catch {
        throw
    }
}

function Install-Terraform {
    param(
        [string]$TargetPath
    )

    Write-SectionHeader "Terraform Installation"

    try {
        # Check if already installed
        $existingTerraform = $null
        $existingVersion = $null

        if (Test-CommandExists "terraform") {
            $existingVersion = (terraform version -json 2>$null | ConvertFrom-Json).terraform_version
            $existingLocation = (Get-Command terraform).Source

            Write-ColorOutput "Terraform $existingVersion is already installed" -Type Info
            Write-Host "  Location: $existingLocation" -ForegroundColor Gray
            Write-Host ""

            $confirmed = Confirm-Action `
                -Title "Terraform Already Installed" `
                -Description "You already have Terraform installed. Do you want to reinstall/upgrade?" `
                -Changes @(
                    "Current version: $existingVersion",
                    "New installation location: $TargetPath",
                    "This may update or downgrade your version",
                    "Existing installation will remain (you can delete it manually later)"
                ) `
                -DefaultChoice "N"

            if (-not $confirmed) {
                Write-ColorOutput "Keeping existing Terraform installation" -Type Info
                return $true
            }
        }

        # Get latest version info
        Write-ColorOutput "Fetching latest Terraform version information..." -Type Info
        $terraformInfo = Get-LatestTerraformVersion
        Write-ColorOutput "Latest version: $($terraformInfo.Version) ($((Get-SystemArchitecture).ToUpper()))" -Type Success

        # Explain what we're about to do
        Write-Host ""
        $confirmed = Confirm-Action `
            -Title "Install Terraform $($terraformInfo.Version)" `
            -Description "Download and install HashiCorp Terraform CLI tool" `
            -Changes @(
                "Download: $($terraformInfo.FileName) (~40 MB)",
                "Extract to: $TargetPath",
                "Add to your PATH environment variable",
                "No administrator privileges required"
            )

        if (-not $confirmed) {
            Write-ColorOutput "Terraform installation cancelled" -Type Warning
            return $false
        }

        # Create temp directory
        if (-not (Test-Path $Config.TempPath)) {
            New-Item -ItemType Directory -Path $Config.TempPath -Force | Out-Null
        }

        $zipPath = Join-Path $Config.TempPath $terraformInfo.FileName

        # Download
        Write-ColorOutput "Downloading Terraform $($terraformInfo.Version)..." -Type Info
        Write-Explanation "This may take a minute depending on your internet speed"
        Write-Host "  URL: $($terraformInfo.DownloadUrl)" -ForegroundColor Gray
        Write-Host ""

        try {
            # Show progress for large download
            $ProgressPreference = "Continue"
            Invoke-WebRequest -Uri $terraformInfo.DownloadUrl -OutFile $zipPath -UseBasicParsing
            $ProgressPreference = "SilentlyContinue"

            Write-ColorOutput "Download complete" -Type Success
        } catch {
            Write-ColorOutput "Download failed: $_" -Type Error
            throw
        }

        # Create installation directory
        if (-not (Test-Path $TargetPath)) {
            Write-ColorOutput "Creating installation directory: $TargetPath" -Type Info
            New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
        }

        # Extract
        Write-ColorOutput "Extracting Terraform..." -Type Info
        try {
            Expand-Archive -Path $zipPath -DestinationPath $TargetPath -Force
            Write-ColorOutput "Extraction complete" -Type Success
        } catch {
            Write-ColorOutput "Extraction failed: $_" -Type Error
            throw
        }

        # Verify extraction
        $terraformExe = Join-Path $TargetPath "terraform.exe"
        if (-not (Test-Path $terraformExe)) {
            throw "Terraform.exe not found after extraction"
        }

        # Add to PATH
        Write-Host ""
        Write-ColorOutput "Terraform binary installed successfully" -Type Success
        Write-Host "  Location: $terraformExe" -ForegroundColor Gray
        Write-Host ""

        # Offer PATH choice
        if (Test-Administrator) {
            Write-Host "  You're running as Administrator. Choose PATH scope:" -ForegroundColor Cyan
            Write-Host "    [S] System PATH (all users)" -ForegroundColor White
            Write-Host "    [U] User PATH (your account only)" -ForegroundColor White
            Write-Host "    [N] Skip PATH update (manual setup)" -ForegroundColor White
            Write-Host ""
            Write-Host "  Choice (S/U/N): " -ForegroundColor Yellow -NoNewline

            if ($NonInteractive) {
                $pathChoice = "U"
                Write-Host $pathChoice
            } else {
                $pathChoice = Read-Host
            }

            switch ($pathChoice.ToUpper()) {
                "S" { Add-ToSystemPath -Path $TargetPath }
                "U" { Add-ToUserPath -Path $TargetPath }
                "N" {
                    Write-ColorOutput "Skipped PATH update" -Type Warning
                    Write-Host "  To use Terraform, either:" -ForegroundColor Yellow
                    Write-Host "    1. Use full path: $terraformExe" -ForegroundColor Gray
                    Write-Host "    2. Add manually: `$env:Path += ';$TargetPath'" -ForegroundColor Gray
                }
                default { Add-ToUserPath -Path $TargetPath }
            }
        } else {
            Add-ToUserPath -Path $TargetPath
        }

        # Verify installation
        Write-Host ""
        Write-ColorOutput "Verifying installation..." -Type Info
        Start-Sleep -Seconds 2

        # Refresh PATH for verification
        $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                    [Environment]::GetEnvironmentVariable("Path", "User")

        if (Test-CommandExists "terraform") {
            $installedVersion = & terraform version -json | ConvertFrom-Json | Select-Object -ExpandProperty terraform_version
            Write-ColorOutput "Terraform $installedVersion verified!" -Type Success
            Write-Host ""

            # Test run
            Write-Host "  Quick test:" -ForegroundColor Cyan
            & terraform version
        } else {
            Write-ColorOutput "Note: Terraform installed but not in PATH yet" -Type Warning
            Write-Explanation "Restart your terminal and run: terraform version"
        }

        # Cleanup
        Write-Host ""
        if (Test-Path $zipPath) {
            $confirmed = Confirm-Action `
                -Title "Clean Up Download" `
                -Description "Remove the downloaded ZIP file to save disk space" `
                -Changes @("Delete: $zipPath")

            if ($confirmed) {
                Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
                Write-ColorOutput "Download cleaned up" -Type Success
            }
        }

        return $true

    } catch {
        Write-ColorOutput "Terraform installation failed: $_" -Type Error
        return $false
    }
}

function Install-VSCode {
    Write-SectionHeader "Visual Studio Code Installation"

    try {
        # Check if already installed
        $vscodePaths = @(
            "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
            "$env:ProgramFiles\Microsoft VS Code\Code.exe",
            "$env:ProgramFiles(x86)\Microsoft VS Code\Code.exe"
        )

        $existingInstall = $vscodePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

        if ($existingInstall) {
            Write-ColorOutput "VS Code is already installed" -Type Info
            Write-Host "  Location: $existingInstall" -ForegroundColor Gray
            Write-Host ""

            $confirmed = Confirm-Action `
                -Title "VS Code Already Installed" `
                -Description "Visual Studio Code is already on your system. Reinstall/upgrade?" `
                -Changes @(
                    "Current installation: $existingInstall",
                    "This will update to the latest version",
                    "Your settings and extensions will be preserved"
                ) `
                -DefaultChoice "N"

            if (-not $confirmed) {
                Write-ColorOutput "Keeping existing VS Code installation" -Type Info
                return $true
            }
        }

        # Determine install type
        $isAdmin = Test-Administrator
        $installType = "User"
        $installUrl = $Config.VSCodeUserUrl

        if ($isAdmin) {
            Write-Host ""
            Write-Host "  Choose installation type:" -ForegroundColor Cyan
            Write-Host "    [U] User Install (recommended, your account only)" -ForegroundColor White
            Write-Host "    [S] System Install (all users, requires admin)" -ForegroundColor White
            Write-Host ""
            Write-Host "  Choice (U/S): " -ForegroundColor Yellow -NoNewline

            if ($NonInteractive) {
                $choice = "U"
                Write-Host $choice
            } else {
                $choice = Read-Host
            }

            if ($choice -eq "S" -or $choice -eq "s") {
                $installType = "System"
                $installUrl = $Config.VSCodeSystemUrl
            }
        }

        # Explain installation
        Write-Host ""
        $changes = @(
            "Download: VS Code installer (~80 MB)",
            "Install type: $installType",
            "Adds VS Code to your PATH",
            "Adds context menu items (Open with Code)"
        )

        if ($installType -eq "System") {
            $changes += "Requires Administrator privileges"
        }

        $confirmed = Confirm-Action `
            -Title "Install Visual Studio Code" `
            -Description "Download and install Microsoft's free code editor" `
            -Changes $changes

        if (-not $confirmed) {
            Write-ColorOutput "VS Code installation cancelled" -Type Warning
            return $false
        }

        # Create temp directory
        if (-not (Test-Path $Config.TempPath)) {
            New-Item -ItemType Directory -Path $Config.TempPath -Force | Out-Null
        }

        $installerPath = Join-Path $Config.TempPath "VSCodeSetup.exe"

        # Download
        Write-ColorOutput "Downloading VS Code..." -Type Info
        Write-Explanation "This is a large file, please be patient"
        Write-Host ""

        try {
            $ProgressPreference = "Continue"
            Invoke-WebRequest -Uri $installUrl -OutFile $installerPath -UseBasicParsing
            $ProgressPreference = "SilentlyContinue"

            Write-ColorOutput "Download complete" -Type Success
        } catch {
            Write-ColorOutput "Download failed: $_" -Type Error
            throw
        }

        # Install
        Write-Host ""
        Write-ColorOutput "Installing VS Code..." -Type Info
        Write-Explanation "The installer will run silently (no windows will appear)"
        Write-Explanation "This may take a few minutes"
        Write-Host ""

        $installArgs = @(
            "/VERYSILENT",
            "/NORESTART",
            "/MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"
        )

        try {
            $process = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-ColorOutput "VS Code installed successfully!" -Type Success

                # Update PATH for current session
                $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                            [Environment]::GetEnvironmentVariable("Path", "User")

                # Wait for installation to settle
                Start-Sleep -Seconds 5

                # Verify installation
                if (Test-CommandExists "code") {
                    $version = & code --version 2>$null | Select-Object -First 1
                    Write-Host "  Version: $version" -ForegroundColor Gray
                } else {
                    Write-ColorOutput "VS Code installed but 'code' command not found yet" -Type Warning
                    Write-Explanation "Restart your terminal to use the 'code' command"
                }
            } else {
                throw "Installer exited with code: $($process.ExitCode)"
            }
        } catch {
            Write-ColorOutput "Installation failed: $_" -Type Error
            throw
        }

        # Cleanup
        Write-Host ""
        if (Test-Path $installerPath) {
            $confirmed = Confirm-Action `
                -Title "Clean Up Installer" `
                -Description "Remove the downloaded installer to save disk space" `
                -Changes @("Delete: $installerPath (~80 MB)")

            if ($confirmed) {
                Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
                Write-ColorOutput "Installer cleaned up" -Type Success
            }
        }

        return $true

    } catch {
        Write-ColorOutput "VS Code installation failed: $_" -Type Error
        return $false
    }
}

function Install-VSCodeExtensions {
    Write-SectionHeader "VS Code Extensions"

    try {
        # Ensure VS Code CLI is available
        if (-not (Test-CommandExists "code")) {
            Write-ColorOutput "VS Code CLI not available" -Type Error
            Write-Explanation "VS Code must be installed and in your PATH to install extensions"
            Write-Host ""
            Write-Host "  Please:" -ForegroundColor Yellow
            Write-Host "    1. Restart your terminal" -ForegroundColor White
            Write-Host "    2. Run: code --version" -ForegroundColor White
            Write-Host "    3. Then install extensions manually or re-run this script" -ForegroundColor White
            Write-Host ""
            return $false
        }

        # Show extensions
        Write-Host "  The following extensions will enhance your Terraform development:" -ForegroundColor Cyan
        Write-Host ""
        foreach ($ext in $Config.Extensions) {
            Write-Host "  📦 $($ext.Name)" -ForegroundColor White
            Write-Host "     ID: $($ext.Id)" -ForegroundColor Gray
            Write-Host "     $($ext.Description)" -ForegroundColor Gray
            Write-Host ""
        }

        $confirmed = Confirm-Action `
            -Title "Install VS Code Extensions" `
            -Description "Add Terraform and Git support to Visual Studio Code" `
            -Changes @(
                "Install: HashiCorp Terraform extension",
                "Install: GitLens extension",
                "Extensions can be uninstalled later from VS Code",
                "Total download size: ~10 MB"
            )

        if (-not $confirmed) {
            Write-ColorOutput "Extension installation cancelled" -Type Warning
            Write-Host ""
            Write-Host "  You can install them later from VS Code:" -ForegroundColor Yellow
            Write-Host "    1. Open VS Code" -ForegroundColor White
            Write-Host "    2. Press Ctrl+Shift+X" -ForegroundColor White
            Write-Host "    3. Search for 'Terraform' and 'GitLens'" -ForegroundColor White
            Write-Host ""
            return $false
        }

        Write-Host ""
        $successCount = 0
        $failCount = 0

        foreach ($ext in $Config.Extensions) {
            Write-ColorOutput "Installing: $($ext.Name)..." -Type Info
            Write-Host "  ID: $($ext.Id)" -ForegroundColor Gray

            try {
                $output = & code --install-extension $ext.Id --force 2>&1

                if ($LASTEXITCODE -eq 0) {
                    Write-ColorOutput "  ✓ $($ext.Name) installed successfully" -Type Success
                    $successCount++
                } else {
                    Write-ColorOutput "  ✗ Failed to install $($ext.Name)" -Type Warning
                    Write-Verbose "Output: $output"
                    $failCount++
                }
            } catch {
                Write-ColorOutput "  ✗ Error installing $($ext.Name): $_" -Type Error
                $failCount++
            }

            Write-Host ""
            Start-Sleep -Milliseconds 500
        }

        Write-ColorOutput "Extension installation complete" -Type Success
        Write-Host "  Successfully installed: $successCount" -ForegroundColor Green

        if ($failCount -gt 0) {
            Write-Host "  Failed: $failCount" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "  You can install failed extensions manually:" -ForegroundColor Yellow
            foreach ($ext in $Config.Extensions) {
                Write-Host "    code --install-extension $($ext.Id)" -ForegroundColor Gray
            }
        }

        return $true

    } catch {
        Write-ColorOutput "Extension installation failed: $_" -Type Error
        return $false
    }
}

function Show-Summary {
    param(
        [hashtable]$Results
    )

    Write-SectionHeader "Installation Summary"

    # Terraform
    Write-Host "Terraform:" -ForegroundColor Cyan
    if ($Results.Terraform) {
        Write-ColorOutput "  ✓ Installed" -Type Success
        if (Test-CommandExists "terraform") {
            $tfVersion = & terraform version -json 2>$null | ConvertFrom-Json | Select-Object -ExpandProperty terraform_version
            $tfPath = (Get-Command terraform).Source
            Write-Host "    Version: $tfVersion" -ForegroundColor Gray
            Write-Host "    Location: $tfPath" -ForegroundColor Gray
        }
    } else {
        Write-ColorOutput "  ✗ Not installed or cancelled" -Type Warning
    }

    Write-Host ""

    # VS Code
    Write-Host "Visual Studio Code:" -ForegroundColor Cyan
    if ($Results.VSCode) {
        Write-ColorOutput "  ✓ Installed" -Type Success
        if (Test-CommandExists "code") {
            $codeVersion = & code --version 2>$null | Select-Object -First 1
            $codePath = (Get-Command code).Source
            Write-Host "    Version: $codeVersion" -ForegroundColor Gray
            Write-Host "    Location: $codePath" -ForegroundColor Gray
        }
    } else {
        Write-ColorOutput "  ✗ Not installed or cancelled" -Type Warning
    }

    Write-Host ""

    # Extensions
    Write-Host "VS Code Extensions:" -ForegroundColor Cyan
    if ($Results.Extensions) {
        Write-ColorOutput "  ✓ Installation attempted" -Type Success
        if (Test-CommandExists "code") {
            $installedExtensions = & code --list-extensions 2>$null
            foreach ($ext in $Config.Extensions) {
                if ($installedExtensions -contains $ext.Id) {
                    Write-Host "    ✓ $($ext.Name)" -ForegroundColor Green
                } else {
                    Write-Host "    ✗ $($ext.Name) (install manually)" -ForegroundColor Yellow
                }
            }
        }
    } else {
        Write-ColorOutput "  ✗ Not installed or cancelled" -Type Warning
    }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host ""
}

function Show-NextSteps {
    param([hashtable]$Results)

    Write-ColorOutput "Next Steps:" -Type Header
    Write-Host ""

    $step = 1

    # Always recommend terminal restart
    Write-Host "  $step. " -ForegroundColor Yellow -NoNewline
    Write-Host "Close and reopen your terminal/PowerShell" -ForegroundColor White
    Write-Explanation "This ensures all PATH changes are loaded"
    $step++
    Write-Host ""

    # Terraform verification
    if ($Results.Terraform) {
        Write-Host "  $step. " -ForegroundColor Yellow -NoNewline
        Write-Host "Verify Terraform installation:" -ForegroundColor White
        Write-Host "     terraform version" -ForegroundColor Cyan
        $step++
        Write-Host ""
    }

    # VS Code verification
    if ($Results.VSCode) {
        Write-Host "  $step. " -ForegroundColor Yellow -NoNewline
        Write-Host "Verify VS Code installation:" -ForegroundColor White
        Write-Host "     code --version" -ForegroundColor Cyan
        $step++
        Write-Host ""
    }

    # Quick start
    Write-Host "  $step. " -ForegroundColor Yellow -NoNewline
    Write-Host "Quick start with Terraform:" -ForegroundColor White
    Write-Host "     mkdir my-terraform-project" -ForegroundColor Cyan
    Write-Host "     cd my-terraform-project" -ForegroundColor Cyan
    Write-Host "     code ." -ForegroundColor Cyan
    Write-Host "     terraform init" -ForegroundColor Cyan
    $step++
    Write-Host ""

    # Resources
    Write-Host "  📚 Learning Resources:" -ForegroundColor Cyan
    Write-Host "     • Terraform Docs: https://developer.hashicorp.com/terraform/docs" -ForegroundColor Gray
    Write-Host "     • VS Code Docs: https://code.visualstudio.com/docs" -ForegroundColor Gray
    Write-Host "     • Terraform Tutorial: https://developer.hashicorp.com/terraform/tutorials" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# Main Execution
# ============================================================================

function Main {
    # Clear screen for better visibility
    Clear-Host

    # Show resource links FIRST
    Show-ResourceLinks

    # If user only wants to see links, exit now
    if ($ShowLinksOnly) {
        Write-Host ""
        Write-ColorOutput "Resource links displayed. Use these for manual installation." -Type Info
        Write-Host ""
        Write-Host "To proceed with automated installation, run:" -ForegroundColor Cyan
        Write-Host "  .\Install-CTFTools.ps1" -ForegroundColor White
        Write-Host ""
        exit 0
    }

    # Ask if user wants to proceed or exit
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host ""
    Write-ColorOutput "You have three options:" -Type Question
    Write-Host ""
    Write-Host "  [1] Continue with automated installation (recommended)" -ForegroundColor Green
    Write-Host "  [2] Save these links and install manually later" -ForegroundColor Yellow
    Write-Host "  [3] Exit now" -ForegroundColor Red
    Write-Host ""

    if (-not $NonInteractive) {
        Write-Host "Enter your choice (1/2/3): " -ForegroundColor Yellow -NoNewline
        $choice = Read-Host

        switch ($choice) {
            "2" {
                Write-Host ""
                Write-ColorOutput "Manual installation selected" -Type Info
                Write-Host ""
                Write-Host "Follow these steps for manual installation:" -ForegroundColor Cyan
                Write-Host "  1. Download Terraform from the link above" -ForegroundColor White
                Write-Host "  2. Extract to: $InstallPath" -ForegroundColor White
                Write-Host "  3. Add to PATH: System Settings > Environment Variables" -ForegroundColor White
                Write-Host "  4. Download and install VS Code" -ForegroundColor White
                Write-Host "  5. Install extensions from VS Code marketplace" -ForegroundColor White
                Write-Host ""
                exit 0
            }
            "3" {
                Write-ColorOutput "Installation cancelled" -Type Warning
                exit 0
            }
            default {
                # Continue with installation (option 1 or empty)
            }
        }
    }

    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║                                                               ║" -ForegroundColor Magenta
    Write-Host "║        Starting Automated Installation Process               ║" -ForegroundColor Magenta
    Write-Host "║                                                               ║" -ForegroundColor Magenta
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""

    # Check privileges
    $isAdmin = Test-Administrator
    if ($isAdmin) {
        Write-ColorOutput "Running with Administrator privileges" -Type Success
        Write-Explanation "You'll have the option to install for all users"
    } else {
        Write-ColorOutput "Running without Administrator privileges" -Type Info
        Write-Explanation "Installation will be user-specific (recommended)"
    }
    Write-Host ""

    # Track results
    $results = @{
        Terraform  = $false
        VSCode     = $false
        Extensions = $false
    }

    # Install Terraform
    Write-Host ""
    $results.Terraform = Install-Terraform -TargetPath $InstallPath

    # Install VS Code
    Write-Host ""
    $results.VSCode = Install-VSCode

    # Install Extensions (only if VS Code available)
    if ($results.VSCode -or (Test-CommandExists "code")) {
        Write-Host ""
        Write-ColorOutput "Waiting for VS Code to initialize..." -Type Info
        Start-Sleep -Seconds 3
        $results.Extensions = Install-VSCodeExtensions
    } else {
        Write-ColorOutput "Skipping extensions (VS Code not available)" -Type Warning
    }

    # Show summary
    Write-Host ""
    Show-Summary -Results $results

    # Show next steps
    Show-NextSteps -Results $results

    # Cleanup temp directory
    if (Test-Path $Config.TempPath) {
        Write-ColorOutput "Cleaning up temporary files..." -Type Info
        try {
            Remove-Item -Path $Config.TempPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-ColorOutput "Cleanup complete" -Type Success
        } catch {
            Write-ColorOutput "Could not clean up temp directory: $($Config.TempPath)" -Type Warning
        }
    }

    Write-Host ""
    Write-ColorOutput "Installation process complete! 🎉" -Type Success
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "⚠️  REMEMBER: " -ForegroundColor Yellow -NoNewline
    Write-Host "Restart your terminal for PATH changes to take effect!" -ForegroundColor White
    Write-Host ""
}

# ============================================================================
# Script Entry Point
# ============================================================================

try {
    Main
} catch {
    Write-Host ""
    Write-ColorOutput "Fatal error occurred: $_" -Type Error
    Write-Host ""
    Write-Host "Stack Trace:" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Gray
    Write-Host ""
    Write-Host "If you need help, please report this error with the stack trace above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}