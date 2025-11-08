# Terraform Best Practices

## Code Organization
- One challenge per file
- Use meaningful variable names
- Add comments to explain logic

## State Management
- Don't commit `.tfstate` files
- Use `.gitignore` properly
- Understand state locking

## Testing
- Always run `terraform plan` first
- Use `terraform console` for expressions
- Test incrementally

## Security
- Keep `terraform.tfvars` private
- Don't commit sensitive data
- Use `.gitignore`