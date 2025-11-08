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
#
# HINTS:
#   - Use toset() to create a set
#   - Required items: ["alpha", "beta", "gamma", "delta"]
#   - Access created resources with: resource_type.resource_name[each_key]
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
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "foreach_wizard" {
#   challenge_id = "for_each_wizard"
#   flag         = "flag{f0r_34ch_1s_p0w3rful}"
#
#   proof_of_work = {
#     items = join(",", sort(local.greek_letters))
#   }
# }

# output "challenge_06_result" {
#   value = ctfchallenge_flag_validator.foreach_wizard.message
# }