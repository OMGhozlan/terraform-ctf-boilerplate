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
#
# HINTS:
#   - Use locals to break down the computation
#   - join() can concatenate strings
#   - Functions can be nested
#   - Test in terraform console
# ============================================================================

# TODO: Create locals for step-by-step computation

# locals {
#   # Step 1: Combine the strings
#   strings = ["terraform", "expressions", "rock"]
#   combined = join("", local.strings)
#   
#   # Step 2: Hash the combined string
#   hashed = sha256(local.combined)
#   
#   # Step 3: Base64 encode the hash
#   encoded = base64encode(local.hashed)
# }

# ============================================================================
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "expression_expert" {
#   challenge_id = "expression_expert"
#   flag         = "flag{3xpr3ss10ns_unl0ck3d}"
#
#   proof_of_work = {
#     computed_value = local.encoded
#   }
# }

# output "challenge_02_result" {
#   value = ctfchallenge_flag_validator.expression_expert.message
# }