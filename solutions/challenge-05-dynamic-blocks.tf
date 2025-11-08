# ============================================================================
# Challenge 5: Dynamic Blocks (300 points)
# ============================================================================
# Difficulty: 🟡 Intermediate
# Category: Advanced Syntax
#
# OBJECTIVE:
#   Use dynamic blocks or for_each to generate multiple configurations
#
# REQUIREMENTS:
#   Generate at least 5 dynamic blocks or resources
#
# LEARNING GOALS:
#   - for_each meta-argument
#   - Dynamic configuration generation
#   - Working with maps and sets
#
# HINTS:
#   - Create a map or set with 5+ items
#   - Use for_each on a resource
#   - Count the generated resources
# ============================================================================

# TODO: Define your configuration data
# locals {
#   port_configs = {
#     http  = { port = 80, protocol = "tcp" }
#     https = { port = 443, protocol = "tcp" }
#     # Add more...
#   }
# }

# TODO: Create resources using for_each
# resource "null_resource" "dynamic_rules" {
#   for_each = local.port_configs
#
#   triggers = {
#     name     = each.key
#     port     = each.value.port
#     protocol = each.value.protocol
#   }
# }

# ============================================================================
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "dynamic_blocks" {
#   challenge_id = "dynamic_blocks"
#   flag         = "flag{dyn4m1c_bl0cks_r0ck}"
#
#   proof_of_work = {
#     dynamic_block_count = tostring(length(local.port_configs))
#   }
# }

# output "challenge_05_result" {
#   value = ctfchallenge_flag_validator.dynamic_blocks.message
# }