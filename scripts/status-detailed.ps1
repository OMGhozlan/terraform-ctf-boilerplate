# ============================================================================
# Terraform CTF Challenge Status Script - Detailed (PowerShell)
# ============================================================================

[CmdletBinding()]
param(
    [switch]$Detailed,
    [switch]$JsonOutput,
    [switch]$NoColor
)

$ErrorActionPreference = "SilentlyContinue"

# Color helper functions
function Write-Colored {
    param(
        [string]$Text,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    
    if ($NoColor) {
        if ($NoNewline) {
            Write-Host $Text -NoNewline
        } else {
            Write-Host $Text
        }
    } else {
        if ($NoNewline) {
            Write-Host $Text -ForegroundColor $Color -NoNewline
        } else {
            Write-Host $Text -ForegroundColor $Color
        }
    }
}

# Get Terraform output as object
function Get-TerraformOutput {
    param([string]$OutputName)
    
    try {
        $json = terraform output -json $OutputName 2>$null
        if ($json) {
            return $json | ConvertFrom-Json
        }
    } catch {
        Write-Warning "Failed to get output: $OutputName"
    }
    return $null
}

# Main script
Clear-Host

if ($JsonOutput) {
    # Output as JSON for programmatic use
    $output = @{
        summary = Get-TerraformOutput "public_summary"
        progress = terraform output -raw progress_bar 2>$null
        status = Get-TerraformOutput "challenge_status"
        statistics = Get-TerraformOutput "statistics"
    }
    $output | ConvertTo-Json -Depth 10
    exit
}

# Display header
Write-Host ""
Write-Colored "╔════════════════════════════════════════════╗" "Cyan"
Write-Colored "║     Terraform CTF Challenge Status        ║" "Cyan"
Write-Colored "╚════════════════════════════════════════════╝" "Cyan"
Write-Host ""

# Progress bar
$progress = terraform output -raw progress_bar 2>$null
if ($progress) {
    Write-Colored $progress "Blue"
    Write-Host ""
}

# Summary
$summary = Get-TerraformOutput "public_summary"
if ($summary) {
    Write-Colored "Player: " "Yellow" -NoNewline
    Write-Colored $summary.player_name "White"
    
    Write-Colored "Score: " "Yellow" -NoNewline
    Write-Colored "$($summary.total_earned) / $($summary.total_possible) points " "White" -NoNewline
    Write-Colored "($($summary.remaining_points) remaining)" "Gray"
    
    Write-Colored "Challenges: " "Yellow" -NoNewline
    Write-Colored "$($summary.challenges_completed) / $($summary.challenges_enabled) completed " "White" -NoNewline
    Write-Colored "($($summary.completion_percentage))" "Cyan"
    
    if ($summary.puzzle_solved) {
        Write-Colored "Bonus Puzzle: " "Yellow" -NoNewline
        Write-Colored "✓ Solved" "Green"
    }
    Write-Host ""
}

# Challenge status
Write-Colored "Enabled Challenges:" "Cyan"
Write-Colored "─────────────────────────────────────────" "DarkGray"

$status = Get-TerraformOutput "challenge_status"
if ($status) {
    $status.PSObject.Properties | Where-Object { $_.Value.enabled -eq $true } | Sort-Object Name | ForEach-Object {
        $challengeName = ($_.Name -replace "_", " ").ToUpper()
        
        if ($_.Value.completed) {
            Write-Colored "✓ " "Green" -NoNewline
            Write-Colored $challengeName "White" -NoNewline
            Write-Colored " - " "Gray" -NoNewline
            Write-Colored "$($_.Value.earned)" "Green" -NoNewline
            Write-Colored "/" "Gray" -NoNewline
            Write-Colored "$($_.Value.points) points" "White"
        } else {
            Write-Colored "✗ " "Red" -NoNewline
            Write-Colored $challengeName "White" -NoNewline
            Write-Colored " - " "Gray" -NoNewline
            Write-Colored "$($_.Value.points) points" "DarkGray"
        }
    }
}

# Disabled challenges
$disabled = Get-TerraformOutput "disabled_challenges"
if ($disabled -and $disabled.Count -gt 0) {
    Write-Host ""
    Write-Colored "Disabled Challenges:" "Cyan"
    Write-Colored "─────────────────────────────────────────" "DarkGray"
    
    $disabled | ForEach-Object {
        Write-Colored "⊘ " "Yellow" -NoNewline
        Write-Colored "$($_.name) - $($_.points) points" "DarkGray"
    }
}

Write-Host ""

# Statistics by difficulty
$stats = Get-TerraformOutput "statistics"
if ($stats) {
    Write-Colored "By Difficulty:" "Cyan"
    Write-Colored "─────────────────────────────────────────" "DarkGray"
    
    # Beginner
    Write-Colored "Beginner:     " "Green" -NoNewline
    $begComp = $stats.by_difficulty.beginner.completed
    $begEnabl = $stats.by_difficulty.beginner.enabled
    if ($begComp -eq $begEnabl -and $begEnabl -gt 0) {
        Write-Colored "$begComp/$begEnabl completed ✓" "Green"
    } else {
        Write-Colored "$begComp/$begEnabl completed" "White"
    }
    
    # Intermediate
    Write-Colored "Intermediate: " "Yellow" -NoNewline
    $intComp = $stats.by_difficulty.intermediate.completed
    $intEnabl = $stats.by_difficulty.intermediate.enabled
    if ($intComp -eq $intEnabl -and $intEnabl -gt 0) {
        Write-Colored "$intComp/$intEnabl completed ✓" "Green"
    } else {
        Write-Colored "$intComp/$intEnabl completed" "White"
    }
    
    # Advanced
    Write-Colored "Advanced:     " "Red" -NoNewline
    $advComp = $stats.by_difficulty.advanced.completed
    $advEnabl = $stats.by_difficulty.advanced.enabled
    if ($advComp -eq $advEnabl -and $advEnabl -gt 0) {
        Write-Colored "$advComp/$advEnabl completed ✓" "Green"
    } else {
        Write-Colored "$advComp/$advEnabl completed" "White"
    }
}

# Detailed information
if ($Detailed) {
    Write-Host ""
    Write-Colored "═══════════════════════════════════════════" "Cyan"
    Write-Colored "Detailed Breakdown:" "Cyan"
    Write-Colored "═══════════════════════════════════════════" "Cyan"
    
    $enabled = Get-TerraformOutput "enabled_challenges"
    if ($enabled) {
        $enabled | ForEach-Object {
            Write-Host ""
            Write-Colored "Challenge: " "Yellow" -NoNewline
            Write-Colored $_.name "White"
            
            Write-Colored "  Difficulty: " "Gray" -NoNewline
            switch ($_.difficulty) {
                "beginner" { Write-Colored $_.difficulty "Green" }
                "intermediate" { Write-Colored $_.difficulty "Yellow" }
                "advanced" { Write-Colored $_.difficulty "Red" }
            }
            
            Write-Colored "  Points: " "Gray" -NoNewline
            Write-Colored $_.points "Cyan"
            
            Write-Colored "  Category: " "Gray" -NoNewline
            Write-Colored $_.category "White"
            
            Write-Colored "  Status: " "Gray" -NoNewline
            if ($_.completed) {
                Write-Colored "✓ Completed" "Green"
            } else {
                Write-Colored "✗ Not completed" "Red"
            }
        }
    }
}

Write-Host ""
Write-Colored "─────────────────────────────────────────" "DarkGray"
Write-Colored "Commands:" "Cyan"
Write-Colored "  terraform output challenge_results" "Gray"
Write-Colored "  terraform output score_breakdown" "Gray"
Write-Colored "  terraform output statistics" "Gray"
Write-Colored ""
Write-Colored "  .\scripts\status.ps1 -Detailed" "Gray"
Write-Colored "  .\scripts\status.ps1 -JsonOutput" "Gray"
Write-Host ""