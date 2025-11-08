# ============================================================================
# Challenge 4: Module Master (400 points)
# ============================================================================
# Difficulty: 🔴 Advanced
# Category: Modules
#
# OBJECTIVE:
#   Create and use Terraform modules for code reusability
#
# REQUIREMENTS:
#   1. Create a module in the modules/ directory
#   2. Use the module in your configuration
#   3. Reference module outputs in your proof of work
#
# LEARNING GOALS:
#   - Module structure (main.tf, variables.tf, outputs.tf)
#   - Module inputs and outputs
#   - Module composition
#   - Cross-module references
#
# HINTS:
#   - Create modules/example-module/ directory
#   - Module must have at least one output
#   - Use module.module_name.output_name syntax
#   - Keep it simple - even a basic module works
#   - Proof should reference the module output
#
# CTF PARADIGM:
#   - Create a working module
#   - Use it in your config
#   - Submit proof with module reference
#   - Flag is REVEALED upon success!
#
# MODULE STRUCTURE:
#   modules/example-module/
#   ├── main.tf       (module resources)
#   ├── variables.tf  (module inputs)
#   └── outputs.tf    (module outputs)
# ============================================================================

# TODO: Create your module first in modules/example-module/ directory
# Then use it here:

# module "my_module" {
#   source = "./modules/example-module"
#
#   # module inputs here
#   name = "ctf-challenge"
# }

# TODO: Create a resource that uses the module output
# resource "null_resource" "module_consumer" {
#   triggers = {
#     module_output = module.my_module.some_output
#   }
# }

# ============================================================================
# Validation & Flag Capture
# ============================================================================

# resource "ctfchallenge_flag_validator" "module_master" {
#   challenge_id = "module_master"
#
#   proof_of_work = {
#     module_output = "module.my_module.some_output = ${module.my_module.some_output}"
#   }
# }

# output "challenge_04_result" {
#   value = ctfchallenge_flag_validator.module_master.message
# }

# output "challenge_04_flag" {
#   description = "🏴 Captured flag!"
#   value       = ctfchallenge_flag_validator.module_master.flag
#   sensitive   = true
# }

# ============================================================================
# View your captured flag with:
#   terraform output -raw challenge_04_flag
# ============================================================================