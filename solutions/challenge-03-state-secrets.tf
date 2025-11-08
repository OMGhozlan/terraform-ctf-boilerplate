# ============================================================================
# Challenge 3: State Secrets (200 points)
# ============================================================================
# Difficulty: 🟢 Beginner
# Category: State Management
#
# OBJECTIVE:
#   Understand Terraform state and discover the "magic number"
#
# REQUIREMENTS:
#   Find the magic number and create that many resources
#
# LEARNING GOALS:
#   - Terraform state tracking
#   - count meta-argument
#   - Resource naming and tracking
#   - The significance of 42 in tech culture
#
# HINTS:
#   - "The answer to life, the universe, and everything..."
#   - Douglas Adams fans will know this number
#   - It's between 40 and 45
#   - Think "Hitchhiker's Guide to the Galaxy"
#   - Seriously, it's 42!
#
# CTF PARADIGM:
#   - Discover the magic number
#   - Create that many resources
#   - Submit as proof
#   - Flag is REVEALED upon success!
# ============================================================================

# TODO: Define the magic number
# locals {
#   magic_number = ??  # What's the answer to everything?
# }

# TODO: Create resources using count
# resource "null_resource" "state_tracking" {
#   count = local.magic_number
#
#   triggers = {
#     index = count.index
#     total = local.magic_number
#   }
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "state_secrets" {
#   challenge_id = "state_secrets"
#
#   proof_of_work = {
#     resource_count = tostring(local.magic_number)
#   }
# }

# output "challenge_03_result" {
#   value = ctfchallenge_flag_validator.state_secrets.message
# }

# output "challenge_03_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.state_secrets.flag
#   sensitive   = true
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_03_flag
# ============================================================================