# ============================================================================
# Outputs
# ============================================================================

# ============================================================================
# CAPTURED FLAGS - Your Rewards!
# ============================================================================
# Flags are revealed here when you successfully complete challenges
# Use: terraform output -json captured_flags | jq -r
# Or: terraform output -json captured_flags | jq -r '.challenge_name'
# ============================================================================

# This will be populated as you complete challenges
# output "captured_flags" {
#   description = "🏴 Flags you've captured!"
#   sensitive   = true
#   value = {
#     # Flags appear here as you complete challenges
#     # terraform_basics = try(ctfchallenge_flag_validator.terraform_basics.flag, "🔒 Not captured yet")
#     # expression_expert = try(ctfchallenge_flag_validator.expression_expert.flag, "🔒 Not captured yet")
#     # ... etc
#   }
# }

# ============================================================================
# PROGRESS TRACKING
# ============================================================================

# Progress tracking
output "completion_percentage" {
  description = "Your completion percentage"
  value       = "Start by editing solutions/challenge-01-terraform-basics.tf and run 'terraform apply'"
}

# ============================================================================
# GETTING STARTED
# ============================================================================

# Available challenges information
output "getting_started" {
  description = "Getting started guide"
  value = {
    welcome = "🎯 Welcome to Terraform CTF Challenge!"
    
    ctf_paradigm = {
      step_1 = "Complete challenge requirements"
      step_2 = "Submit proof of work"
      step_3 = "Capture the flag as your reward!"
      note   = "Flags are OUTPUTS (rewards), not INPUTS (requirements)"
    }
    
    quick_start = {
      step_1 = "Copy terraform.tfvars.example to terraform.tfvars"
      step_2 = "Edit your player_name in terraform.tfvars"
      step_3 = "Start with solutions/challenge-01-terraform-basics.tf"
      step_4 = "Uncomment and complete the challenge code"
      step_5 = "Run 'terraform plan' to preview"
      step_6 = "Run 'terraform apply' to validate and capture the flag"
      step_7 = "View flags with 'terraform output -json captured_flags | jq -r'"
    }
    
    tips = [
      "🟢 Start with beginner challenges (01, 03, 07)",
      "📖 Read docs/CHALLENGES.md for details",
      "💡 Enable hints in terraform.tfvars if stuck (costs points!)",
      "📝 Each challenge file has detailed comments",
      "🧪 Use 'terraform console' to test expressions",
      "🏴 Flags are revealed when you succeed!"
    ]
    
    commands = {
      view_progress   = "terraform output completion_percentage"
      view_flags      = "terraform output -json captured_flags | jq -r"
      view_challenges = "terraform output all_challenges"
      run_build       = ".\\Build.ps1 status  (Windows) or ./build.sh status (Linux/Mac)"
    }
  }
}

# List all challenges
output "all_challenges" {
  description = "List of all available challenges"
  value       = data.ctfchallenge_list.all_challenges.challenges
}

# Hints (if enabled)
# output "hints" {
#   description = "Requested hints (enable in terraform.tfvars)"
#   value = var.enable_hints ? "Hints will appear here" : "Enable hints in terraform.tfvars"
# }