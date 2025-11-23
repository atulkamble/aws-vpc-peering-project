#!/bin/bash

# VPC Peering Connectivity Test Script
# This script tests the connectivity between EC2 instances across peered VPCs

set -e

echo "======================================"
echo "VPC Peering Connectivity Test"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get outputs from Terraform
echo "Retrieving Terraform outputs..."
EC2_A_PUBLIC_IP=$(terraform output -raw ec2_a_public_ip 2>/dev/null)
EC2_A_PRIVATE_IP=$(terraform output -raw ec2_a_private_ip 2>/dev/null)
EC2_B_PUBLIC_IP=$(terraform output -raw ec2_b_public_ip 2>/dev/null)
EC2_B_PRIVATE_IP=$(terraform output -raw ec2_b_private_ip 2>/dev/null)
PEERING_ID=$(terraform output -raw peering_id 2>/dev/null)

if [ -z "$EC2_A_PUBLIC_IP" ] || [ -z "$EC2_B_PUBLIC_IP" ]; then
    echo -e "${RED}Error: Could not retrieve instance IPs. Make sure infrastructure is deployed.${NC}"
    exit 1
fi

echo -e "${GREEN}Infrastructure Details:${NC}"
echo "  EC2-A Public IP:  $EC2_A_PUBLIC_IP"
echo "  EC2-A Private IP: $EC2_A_PRIVATE_IP"
echo "  EC2-B Public IP:  $EC2_B_PUBLIC_IP"
echo "  EC2-B Private IP: $EC2_B_PRIVATE_IP"
echo "  Peering ID:       $PEERING_ID"
echo ""

# Check if key file exists
KEY_FILE="mykey.pem"
if [ ! -f "$KEY_FILE" ]; then
    echo -e "${YELLOW}Warning: Key file '$KEY_FILE' not found in current directory${NC}"
    echo "Please ensure you have the correct key file to SSH into instances"
    echo ""
    read -p "Enter path to your key file: " KEY_FILE
    if [ ! -f "$KEY_FILE" ]; then
        echo -e "${RED}Error: Key file not found${NC}"
        exit 1
    fi
fi

# Set correct permissions for key file
chmod 400 "$KEY_FILE"

echo -e "${BLUE}======================================"
echo "Manual Test Instructions"
echo "======================================${NC}"
echo ""
echo "1. SSH into EC2-A:"
echo "   ssh -i $KEY_FILE ec2-user@$EC2_A_PUBLIC_IP"
echo ""
echo "2. From EC2-A, ping EC2-B (private IP):"
echo "   ping -c 4 $EC2_B_PRIVATE_IP"
echo ""
echo "3. From EC2-A, SSH to EC2-B (private IP):"
echo "   ssh ec2-user@$EC2_B_PRIVATE_IP"
echo ""
echo "4. Alternatively, SSH into EC2-B:"
echo "   ssh -i $KEY_FILE ec2-user@$EC2_B_PUBLIC_IP"
echo ""
echo "5. From EC2-B, ping EC2-A (private IP):"
echo "   ping -c 4 $EC2_A_PRIVATE_IP"
echo ""
echo -e "${YELLOW}Note: You may need to wait a few minutes for instances to be fully ready${NC}"
echo ""

# Offer to run automated tests
read -p "Would you like to run automated connectivity tests? (yes/no): " run_tests

if [ "$run_tests" == "yes" ]; then
    echo ""
    echo -e "${BLUE}Running automated tests...${NC}"
    echo ""
    
    # Test 1: SSH connectivity to EC2-A
    echo "Test 1: Checking SSH connectivity to EC2-A..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i "$KEY_FILE" ec2-user@$EC2_A_PUBLIC_IP "echo 'Connected'" &>/dev/null; then
        echo -e "${GREEN}✓ SSH to EC2-A successful${NC}"
    else
        echo -e "${RED}✗ SSH to EC2-A failed${NC}"
    fi
    
    # Test 2: SSH connectivity to EC2-B
    echo "Test 2: Checking SSH connectivity to EC2-B..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i "$KEY_FILE" ec2-user@$EC2_B_PUBLIC_IP "echo 'Connected'" &>/dev/null; then
        echo -e "${GREEN}✓ SSH to EC2-B successful${NC}"
    else
        echo -e "${RED}✗ SSH to EC2-B failed${NC}"
    fi
    
    # Test 3: Ping from EC2-A to EC2-B
    echo "Test 3: Testing ping from EC2-A to EC2-B (private IP)..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i "$KEY_FILE" ec2-user@$EC2_A_PUBLIC_IP "ping -c 4 $EC2_B_PRIVATE_IP" &>/dev/null; then
        echo -e "${GREEN}✓ Ping from EC2-A to EC2-B successful${NC}"
    else
        echo -e "${RED}✗ Ping from EC2-A to EC2-B failed${NC}"
    fi
    
    # Test 4: Ping from EC2-B to EC2-A
    echo "Test 4: Testing ping from EC2-B to EC2-A (private IP)..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i "$KEY_FILE" ec2-user@$EC2_B_PUBLIC_IP "ping -c 4 $EC2_A_PRIVATE_IP" &>/dev/null; then
        echo -e "${GREEN}✓ Ping from EC2-B to EC2-A successful${NC}"
    else
        echo -e "${RED}✗ Ping from EC2-B to EC2-A failed${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}Testing complete!${NC}"
fi

echo ""
echo -e "${YELLOW}======================================"
echo "Troubleshooting Tips"
echo "======================================${NC}"
echo "If tests fail, check:"
echo "  1. VPC Peering connection status (should be 'active')"
echo "  2. Route tables have correct routes"
echo "  3. Security groups allow ICMP and SSH from peer VPC CIDR"
echo "  4. Instances are in 'running' state"
echo ""
