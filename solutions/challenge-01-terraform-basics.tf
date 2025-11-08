# ============================================================================
# Challenge 1: Terraform Basics (100 points)
# ============================================================================
# Difficulty: 🟢 Beginner
# Category: Fundamentals
#
# OBJECTIVE:
#   Understand how Terraform manages resource dependencies and execution order
#
# REQUIREMENTS:
#   1. Create at least 3 resources with explicit dependencies
#   2. Use the depends_on argument to control execution order
#   3. Pass the resource IDs as proof of work
#
# LEARNING GOALS:
#   - Resource dependencies
#   - depends_on meta-argument
#   - Execution order in Terraform
#   - Capturing flags upon successful validation
#
# HINTS:
#   - null_resource is perfect for this challenge
#   - Use depends_on to create a chain
#   - Resource IDs are automatically generated
#   - Flag is revealed when you succeed (not needed beforehand!)
#
# CTF PARADIGM:
#   - Complete the challenge requirements
#   - Submit proof of work
#   - Flag is REVEALED as your reward!
# ============================================================================

# TODO: Create your first resource here
# Example:
# resource "null_resource" "first_step" {
#   triggers = {
#     timestamp = timestamp()
#   }
# }

# TODO: Create your second resource that depends on the first
# resource "null_resource" "second_step" {
#   depends_on = [null_resource.first_step]
#   
#   triggers = {
#     timestamp = timestamp()
#   }
# }

# TODO: Create your third resource that depends on the second
# resource "null_resource" "third_step" {
#   depends_on = [null_resource.second_step]
#   
#   triggers = {
#     timestamp = timestamp()
#   }
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================
# Uncomment and complete the validation block when ready
# Notice: NO flag parameter! The flag is revealed upon successful validation

# resource "ctfchallenge_flag_validator" "terraform_basics" {
#   challenge_id = "terraform_basics"
#
#   proof_of_work = {
#     dependencies = join(",", [
#       null_resource.first_step.id,
#       null_resource.second_step.id,
#       null_resource.third_step.id,
#     ])
#   }
# }

# ============================================================================
# Output - Capture the Flag!
# ============================================================================

# output "challenge_01_result" {
#   description = "Validation result message"
#   value       = ctfchallenge_flag_validator.terraform_basics.message
# }

# output "challenge_01_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.terraform_basics.flag
#   sensitive   = true
# }

# output "challenge_01_points" {
#   description = "Points earned"
#   value       = ctfchallenge_flag_validator.terraform_basics.points
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_01_flag
# ============================================================================