# ============================================================================
# Challenge 7: Data Source Detective (150 points)
# ============================================================================
# Difficulty: 🟢 Beginner
# Category: Data Sources
#
# OBJECTIVE:
#   Query and filter data to find specific information
#
# REQUIREMENTS:
#   Filter a dataset and count the results (should equal 7)
#
# LEARNING GOALS:
#   - Using data sources
#   - Filtering with for expressions
#   - Counting and length functions
#   - Working with maps and filtering
#
# HINTS:
#   - Create a map of items with properties
#   - Filter by multiple criteria (env = "prod" AND active = true)
#   - Count the filtered results
#   - The result should be 7 items
#   - Create at least 10 items total, with 7 matching criteria
#
# CTF PARADIGM:
#   - Create sample data
#   - Filter correctly
#   - Submit the count (7) as proof
#   - Flag is REVEALED upon success!
# ============================================================================

# TODO: Create sample data
# locals {
#   items = {
#     item1  = { type = "compute", env = "prod", active = true }
#     item2  = { type = "compute", env = "prod", active = true }
#     item3  = { type = "database", env = "prod", active = true }
#     item4  = { type = "database", env = "prod", active = true }
#     item5  = { type = "cache", env = "prod", active = true }
#     item6  = { type = "cache", env = "prod", active = true }
#     item7  = { type = "backup", env = "prod", active = true }
#     item8  = { type = "compute", env = "dev", active = true }
#     item9  = { type = "database", env = "dev", active = true }
#     item10 = { type = "compute", env = "prod", active = false }
#   }
#   
#   # Filter: env == "prod" AND active == true
#   filtered = {
#     for name, config in local.items :
#     name => config
#     if config.env == "prod" && config.active == true
#   }
#   
#   count = length(local.filtered)
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "data_source_detective" {
#   challenge_id = "data_source_detective"
#
#   proof_of_work = {
#     filtered_count = tostring(local.count)
#   }
# }

# output "challenge_07_result" {
#   value = ctfchallenge_flag_validator.data_source_detective.message
# }

# output "challenge_07_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.data_source_detective.flag
#   sensitive   = true
# }

# ============================================================================
# Debug output (optional)
# ============================================================================

# output "challenge_07_debug" {
#   value = {
#     total_items    = length(local.items)
#     filtered_items = length(local.filtered)
#     filtered_names = keys(local.filtered)
#   }
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_07_flag
# ============================================================================