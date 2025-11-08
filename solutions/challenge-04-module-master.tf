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
#   3. Reference module outputs
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
# ============================================================================

# TODO: Create your module first in modules/ directory
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
# Validation
# ============================================================================

# resource "ctfchallenge_flag_validator" "module_master" {
#   challenge_id = "module_master"
#   flag         = "flag{m0dul3_c0mp0s1t10n_pr0}"
#
#   proof_of_work = {
#     module_output = "module.my_module.some_output = ${module.my_module.some_output}"
#   }
# }

# output "challenge_04_result" {
#   value = ctfchallenge_flag_validator.module_master.message
# }