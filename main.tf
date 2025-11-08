# ============================================================================
# Terraform CTF Challenge - Main Configuration
# ============================================================================
# This is your main entry point. The provider is configured here.
# Add your challenge solutions in the solutions/ directory.
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
# Challenge solution files are automatically loaded from the current directory
# You can organize them as separate files in solutions/ or keep them here
# ============================================================================

# Uncomment to see all available challenges
# output "available_challenges" {
#   value = data.ctfchallenge_list.all_challenges.challenges
# }