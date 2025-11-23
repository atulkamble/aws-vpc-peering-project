#!/bin/bash

# AWS VPC Peering Test Script
# This script helps verify VPC peering connectivity

set -e

echo "======================================"
echo "AWS VPC Peering Test Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Error: Terraform is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Terraform is installed${NC}"
echo ""

# Validate Terraform configuration
echo "Step 1: Validating Terraform configuration..."
terraform validate
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration is valid${NC}"
else
    echo -e "${RED}✗ Configuration validation failed${NC}"
    exit 1
fi
echo ""

# Format check
echo "Step 2: Checking Terraform formatting..."
terraform fmt -check
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Formatting is correct${NC}"
else
    echo -e "${YELLOW}! Formatting issues found, auto-fixing...${NC}"
    terraform fmt
fi
echo ""

# Generate plan
echo "Step 3: Generating Terraform plan..."
terraform plan -out=tfplan
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Plan generated successfully${NC}"
else
    echo -e "${RED}✗ Plan generation failed${NC}"
    exit 1
fi
echo ""

# Warning before apply
echo -e "${YELLOW}======================================"
echo "WARNING: This will create AWS resources"
echo "that may incur costs!"
echo "======================================${NC}"
echo ""
echo "Resources to be created:"
echo "  - 2 VPCs (VPC-A and VPC-B)"
echo "  - 2 Subnets"
echo "  - 2 Internet Gateways"
echo "  - 2 Route Tables"
echo "  - 2 EC2 Instances (t2.micro)"
echo "  - 2 Security Groups"
echo "  - 1 VPC Peering Connection"
echo ""
read -p "Do you want to apply this configuration? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${YELLOW}Deployment cancelled${NC}"
    rm -f tfplan
    exit 0
fi

# Apply configuration
echo ""
echo "Step 4: Applying Terraform configuration..."
terraform apply tfplan
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Infrastructure deployed successfully${NC}"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    exit 1
fi

# Clean up plan file
rm -f tfplan

echo ""
echo -e "${GREEN}======================================"
echo "Deployment Complete!"
echo "======================================${NC}"
echo ""

# Show outputs
echo "Retrieving outputs..."
terraform output

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Wait 2-3 minutes for EC2 instances to fully initialize"
echo "2. Test connectivity using the commands shown in the output"
echo "3. Remember to run 'terraform destroy' when you're done to avoid charges"
echo ""
