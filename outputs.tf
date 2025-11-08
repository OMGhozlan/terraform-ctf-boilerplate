# ============================================================================
# Outputs
# ============================================================================

# Progress tracking
output "completion_percentage" {
  description = "Your completion percentage"
  value       = "Run 'terraform apply' to see your progress"
}

# Available challenges information
output "getting_started" {
  description = "Getting started guide"
  value = {
    step_1 = "Edit solutions/challenge-01-terraform-basics.tf"
    step_2 = "Run 'terraform plan' to preview"
    step_3 = "Run 'terraform apply' to validate"
    step_4 = "Check 'terraform output completion_percentage'"
    
    tips = [
      "Start with beginner challenges",
      "Read docs/CHALLENGES.md for details",
      "Enable hints in terraform.tfvars if stuck",
      "Each challenge file has comments to guide you"
    ]
  }
}

# List all challenges
output "all_challenges" {
  description = "List of all available challenges"
  value = data.ctfchallenge_list.all_challenges.challenges
}

# Hints (if enabled)
# output "hints" {
#   description = "Requested hints (enable in terraform.tfvars)"
#   value = var.enable_hints ? "Hints will appear here" : "Enable hints in terraform.tfvars"
# }