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
#
# HINTS:
#   - Create a map of items with properties
#   - Filter by multiple criteria
#   - Count the filtered results
#   - The result should be 7 items
# ============================================================================

# TODO: Create sample data
# locals {
#   items = {
#     item1 = { type = "compute", env = "prod", active = true }
#     item2 = { type = "compute", env = "prod", active = true }
#     # Add more items...
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
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "data_source_detective" {
#   challenge_id = "data_source_detective"
#   flag         = "flag{d4t4_s0urc3_sl3uth}"
#
#   proof_of_work = {
#     filtered_count = tostring(local.count)
#   }
# }

# output "challenge_07_result" {
#   value = ctfchallenge_flag_validator.data_source_detective.message
# }