# ============================================================================
# Challenge 8: Cryptographic Compute (500 points)
# ============================================================================
# Difficulty: 🔴 Advanced
# Category: Functions & Cryptography
#
# OBJECTIVE:
#   Chain cryptographic functions to compute a specific hash
#
# REQUIREMENTS:
#   Compute: md5(sha256("terraform_ctf_11_2025"))
#
# LEARNING GOALS:
#   - md5() function
#   - sha256() function
#   - Function nesting/chaining
#   - Cryptographic operations in Terraform
#
# HINTS:
#   - Start from the inside out
#   - First: sha256("terraform_ctf_11_2025")
#   - Then: md5(result_from_step_1)
#   - Test each step in terraform console
# ============================================================================

# TODO: Create the computation
# locals {
#   secret = "terraform_ctf_11_2025"
#   
#   # Step 1: SHA256 hash
#   sha_hash = sha256(local.secret)
#   
#   # Step 2: MD5 of the SHA256 hash
#   final_hash = md5(local.sha_hash)
# }

# ============================================================================
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "cryptographic_compute" {
#   challenge_id = "cryptographic_compute"
#   flag         = "flag{crypt0_func_m4st3r}"
#
#   proof_of_work = {
#     crypto_hash = local.final_hash
#   }
# }

# output "challenge_08_result" {
#   value = ctfchallenge_flag_validator.cryptographic_compute.message
# }