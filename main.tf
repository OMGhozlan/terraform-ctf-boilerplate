# ============================================================================
# Terraform CTF Challenge - Main Configuration
# ============================================================================
# This is your main entry point. The provider is configured here.
# Add your challenge solutions in the solutions/ directory.
#
# CTF PARADIGM:
# - Complete challenges to CAPTURE flags (they're revealed as rewards!)
# - Flags are NOT inputs - they're outputs you earn
# - Each successful validation reveals a flag in the format: flag{...}
# ============================================================================

# Provider Configuration
provider "ctfchallenge" {
  player_name = var.player_name
}

provider "null" {}
provider "random" {}

# ============================================================================
# Data Sources - Get Challenge Information
# ============================================================================

# List all available challenges
data "ctfchallenge_list" "all_challenges" {}

# ============================================================================
# Your Solutions
# ============================================================================
# Challenge solution files are automatically loaded from solutions/ directory
# Each file contains a challenge template with instructions
#
# How it works:
# 1. Edit a challenge file (e.g., solutions/challenge-01-terraform-basics.tf)
# 2. Complete the requirements
# 3. Submit proof of work via ctfchallenge_flag_validator
# 4. Capture the flag as your reward!
# ============================================================================

# Uncomment to see all available challenges
# output "available_challenges" {
#   value = data.ctfchallenge_list.all_challenges.challenges
# }