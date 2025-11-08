# ============================================================================
# Challenge 2: Expression Expert (350 points)
# ============================================================================
# Difficulty: 🟡 Intermediate
# Category: Expressions & Functions
#
# OBJECTIVE:
#   Master Terraform's expression syntax and built-in functions
#
# REQUIREMENTS:
#   Compute: base64encode(sha256("terraform" + "expressions" + "rock"))
#
# LEARNING GOALS:
#   - String concatenation
#   - Function composition
#   - sha256() function
#   - base64encode() function
#   - Testing expressions in terraform console
#
# HINTS:
#   - Use locals to break down the computation
#   - join() can concatenate strings
#   - Functions can be nested
#   - Test in terraform console:
#     > sha256("terraformexpressionsrock")
#     > base64encode(sha256("terraformexpressionsrock"))
#
# CTF PARADIGM:
#   - Complete the computation correctly
#   - Submit the result as proof of work
#   - Flag is REVEALED upon success!
# ============================================================================

# TODO: Create locals for step-by-step computation

# locals {
#   # Step 1: Combine the strings
#   strings = ["terraform", "expressions", "rock"]
#   combined = join("", local.strings)
#   
#   # Step 2: Hash the combined string with SHA256
#   hashed = sha256(local.combined)
#   
#   # Step 3: Base64 encode the hash
#   encoded = base64encode(local.hashed)
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "expression_expert" {
#   challenge_id = "expression_expert"
#
#   proof_of_work = {
#     computed_value = local.encoded
#   }
# }

# output "challenge_02_result" {
#   value = ctfchallenge_flag_validator.expression_expert.message
# }

# output "challenge_02_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.expression_expert.flag
#   sensitive   = true
# }

# ============================================================================
# Debug outputs (optional)
# ============================================================================

# output "challenge_02_debug" {
#   value = {
#     step1 = local.combined
#     step2 = local.hashed
#     step3 = local.encoded
#   }
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_02_flag
# ============================================================================