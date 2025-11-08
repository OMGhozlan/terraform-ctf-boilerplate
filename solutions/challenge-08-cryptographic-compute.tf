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
#   - Testing in terraform console
#
# HINTS:
#   - Start from the inside out
#   - First: sha256("terraform_ctf_11_2025")
#   - Then: md5(result_from_step_1)
#   - Test each step in terraform console:
#     > sha256("terraform_ctf_11_2025")
#     > md5(sha256("terraform_ctf_11_2025"))
#   - Break it into locals for debugging
#
# CTF PARADIGM:
#   - Compute the hash correctly
#   - Submit as proof of work
#   - Flag is REVEALED upon success!
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
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "cryptographic_compute" {
#   challenge_id = "cryptographic_compute"
#
#   proof_of_work = {
#     crypto_hash = local.final_hash
#   }
# }

# output "challenge_08_result" {
#   value = ctfchallenge_flag_validator.cryptographic_compute.message
# }

# output "challenge_08_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.cryptographic_compute.flag
#   sensitive   = true
# }

# ============================================================================
# Debug outputs (optional)
# ============================================================================

# output "challenge_08_debug" {
#   value = {
#     input      = local.secret
#     sha256     = local.sha_hash
#     final_md5  = local.final_hash
#   }
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_08_flag
# ============================================================================