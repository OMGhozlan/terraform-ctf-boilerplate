# General Hints & Tips

## Getting Started
- Read the challenge file comments carefully
- Use `terraform console` to test expressions
- Start with beginner challenges

## Common Patterns
- Use locals for complex computations
- Break down problems into steps
- Test incrementally with `terraform plan`

## Debugging
- Enable detailed logs: `export TF_LOG=DEBUG`
- Use `terraform console` for testing
- Check outputs for feedback

## Functions Reference
- String: `join()`, `split()`, `format()`
- Numeric: `max()`, `min()`, `sum()`
- Encoding: `base64encode()`, `jsonencode()`
- Hashing: `md5()`, `sha256()`, `sha512()`