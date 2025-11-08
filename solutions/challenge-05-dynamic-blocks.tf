# ============================================================================
# Challenge 5: Dynamic Blocks (300 points)
# ============================================================================
# Difficulty: 🟡 Intermediate
# Category: Advanced Syntax
#
# OBJECTIVE:
#   Use for_each to generate multiple configurations dynamically
#
# REQUIREMENTS:
#   Generate at least 5 dynamic blocks or resources
#
# LEARNING GOALS:
#   - for_each meta-argument
#   - Dynamic configuration generation
#   - Working with maps and sets
#   - Counting generated resources
#
# HINTS:
#   - Create a map or set with 5+ items
#   - Use for_each on a resource
#   - Count the generated resources with length()
#   - Port configs are a good example (80, 443, 8080, 8443, 3000)
#
# CTF PARADIGM:
#   - Create 5+ dynamic resources
#   - Submit the count as proof
#   - Flag is REVEALED upon success!
# ============================================================================

# TODO: Define your configuration data
# locals {
#   port_configs = {
#     http      = { port = 80, protocol = "tcp" }
#     https     = { port = 443, protocol = "tcp" }
#     alt_http  = { port = 8080, protocol = "tcp" }
#     alt_https = { port = 8443, protocol = "tcp" }
#     custom    = { port = 3000, protocol = "tcp" }
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
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "dynamic_blocks" {
#   challenge_id = "dynamic_blocks"
#
#   proof_of_work = {
#     dynamic_block_count = tostring(length(local.port_configs))
#   }
# }

# output "challenge_05_result" {
#   value = ctfchallenge_flag_validator.dynamic_blocks.message
# }

# output "challenge_05_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.dynamic_blocks.flag
#   sensitive   = true
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_05_flag
# ============================================================================