#!/bin/bash

echo "🎯 Terraform CTF Challenge"
echo ""

if [ ! -f "terraform.tfstate" ]; then
    echo "Getting started:"
    echo "  1. Copy terraform.tfvars.example to terraform.tfvars"
    echo "  2. Edit your player_name"
    echo "  3. Run: terraform init"
    echo "  4. Run: terraform apply"
    echo ""
else
    echo "Quick commands:"
    echo "  terraform output completion_percentage   # View progress"
    echo "  terraform output getting_started         # Getting started guide"
    echo "  terraform output -json captured_flags    # View captured flags"
    echo ""
fi