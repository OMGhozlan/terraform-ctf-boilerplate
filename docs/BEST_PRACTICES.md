# Terraform Best Practices

## CTF Paradigm Understanding

### Flags are Rewards, Not Inputs
- ✅ **Correct:** Complete challenge → Submit proof → Capture flag
- ❌ **Incorrect:** Know flag beforehand → Submit as input

### How It Works
1. Read challenge requirements
2. Write Terraform code to solve
3. Submit proof of work to `ctfchallenge_flag_validator`
4. Flag is revealed in output if successful

## Code Organization

### File Structure
- One challenge per file in `solutions/`
- Use meaningful variable names
- Add comments to explain logic
- Keep `main.tf` clean (just provider config)

### Example Structure