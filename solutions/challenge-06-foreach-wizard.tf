# ============================================================================
# Challenge 6: For-Each Wizard (250 points)
# ============================================================================
# Difficulty: 🟡 Intermediate
# Category: Loops & Iteration
#
# OBJECTIVE:
#   Use for_each to create multiple resources elegantly
#
# REQUIREMENTS:
#   Create resources for these items: alpha, beta, gamma, delta
#
# LEARNING GOALS:
#   - for_each with sets
#   - for_each with maps
#   - Accessing each.key and each.value
#   - toset() function
#
# HINTS:
#   - Use toset() to create a set from a list
#   - Required items: ["alpha", "beta", "gamma", "delta"]
#   - Access created resources with: resource_type.resource_name[each_key]
#   - Sort the set before joining for proof: sort(local.greek_letters)
#
# CTF PARADIGM:
#   - Create resources for all 4 Greek letters
#   - Submit the items as proof
#   - Flag is REVEALED upon success!
# ============================================================================

# TODO: Create a set with the required items
# locals {
#   greek_letters = toset(["alpha", "beta", "gamma", "delta"])
# }

# TODO: Use for_each to create resources
# resource "null_resource" "greek_letters" {
#   for_each = local.greek_letters
#
#   triggers = {
#     name = each.key
#   }
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "foreach_wizard" {
#   challenge_id = "for_each_wizard"
#
#   proof_of_work = {
#     items = join(",", sort(local.greek_letters))
#   }
# }

# output "challenge_06_result" {
#   value = ctfchallenge_flag_validator.foreach_wizard.message
# }

# output "challenge_06_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.foreach_wizard.flag
#   sensitive   = true
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_06_flag
# ============================================================================