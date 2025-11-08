# ============================================================================
# Input Variables
# ============================================================================

variable "player_name" {
  description = "Your player name for the CTF challenge"
  type        = string
  default     = "anonymous"

  validation {
    condition     = length(var.player_name) > 0
    error_message = "Player name cannot be empty."
  }
}

variable "enable_hints" {
  description = "Whether to request hints (costs points)"
  type        = bool
  default     = false
}

variable "hint_levels" {
  description = "Map of challenge IDs to hint levels to request (0-2)"
  type        = map(number)
  default = {
    terraform_basics      = 0
    expression_expert     = 0
    state_secrets         = 0
    module_master         = 0
    dynamic_blocks        = 0
    for_each_wizard       = 0
    data_source_detective = 0
    cryptographic_compute = 0
  }

  validation {
    condition = alltrue([
      for level in values(var.hint_levels) : level >= 0 && level <= 2
    ])
    error_message = "Hint levels must be between 0 and 2."
  }
}

variable "enable_challenges" {
  description = "Enable or disable specific challenges"
  type = object({
    terraform_basics      = optional(bool, true)
    expression_expert     = optional(bool, true)
    state_secrets         = optional(bool, true)
    module_master         = optional(bool, true)
    dynamic_blocks        = optional(bool, true)
    for_each_wizard       = optional(bool, true)
    data_source_detective = optional(bool, true)
    cryptographic_compute = optional(bool, true)
  })
  default = {}
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "terraform-ctf"
    ManagedBy   = "terraform"
    Environment = "learning"
  }
}