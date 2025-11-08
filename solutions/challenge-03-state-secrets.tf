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
#
# HINTS:
#   - "The answer to life, the universe, and everything..."
#   - Douglas Adams fans will know this number
#   - It's between 40 and 45
#   - Think "Hitchhiker's Guide"
# ============================================================================

# TODO: Define the magic number
# locals {
#   magic_number = ??  # What's the answer?
# }

# TODO: Create resources using count
# resource "null_resource" "state_tracking" {
#   count = local.magic_number
#
#   triggers = {
#     index = count.index
#   }
# }

# ============================================================================
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "state_secrets" {
#   challenge_id = "state_secrets"
#   flag         = "flag{st4t3_m4n4g3m3nt_m4st3r}"
#
#   proof_of_work = {
#     resource_count = tostring(local.magic_number)
#   }
# }

# output "challenge_03_result" {
#   value = ctfchallenge_flag_validator.state_secrets.message
# }