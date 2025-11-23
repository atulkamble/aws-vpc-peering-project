# 🚀 AWS VPC Peering Project

This project demonstrates VPC peering on AWS using Terraform. It creates two VPCs with non-overlapping CIDR ranges, establishes a peering connection, and deploys EC2 instances to test connectivity.

## 🏗 Architecture

```
VPC-A (10.0.0.0/16)
 └── Subnet-A (10.0.1.0/24)
      └── EC2-A (t2.micro)

VPC-B (192.168.0.0/16)
 └── Subnet-B (192.168.1.0/24)
      └── EC2-B (t2.micro)

VPC Peering Connection (auto-accepted)
Bidirectional routing configured
Security groups allow cross-VPC traffic
```

## 📋 Prerequisites

- AWS CLI configured with valid credentials
- Terraform >= 1.0 installed
- An EC2 key pair named "mykey" (or modify `terraform.tfvars`)
- Appropriate AWS permissions to create VPCs, EC2 instances, etc.

## 🚀 Quick Start

### 1. Clone and Setup

```bash
cd aws-vpc-peering-project
```

### 2. Configure Variables (Optional)

Copy the example variables file and customize if needed:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferred values
```

Key variables you can customize:
- `aws_region` - AWS region (default: ap-south-1)
- `key_name` - Your EC2 key pair name (default: mykey)
- `ami_id` - AMI ID for EC2 instances
- CIDR blocks for VPCs and subnets

### 3. Deploy Infrastructure

#### Option A: Using the automated test script

```bash
chmod +x test-deployment.sh
./test-deployment.sh
```

#### Option B: Manual deployment

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

### 4. Test VPC Peering

Wait 2-3 minutes for instances to initialize, then:

#### Option A: Automated testing

```bash
chmod +x test-connectivity.sh
./test-connectivity.sh
```

#### Option B: Manual testing

```bash
# Get instance IPs
terraform output

# SSH into EC2-A
ssh -i mykey.pem ec2-user@<EC2_A_PUBLIC_IP>

# From EC2-A, ping EC2-B using private IP
ping <EC2_B_PRIVATE_IP>

# From EC2-A, SSH to EC2-B using private IP
ssh ec2-user@<EC2_B_PRIVATE_IP>
```

## 📂 Project Structure

```
aws-vpc-peering-project/
├── main.tf                      # Main Terraform configuration
├── variables.tf                 # Variable definitions
├── outputs.tf                   # Output definitions
├── terraform.tfvars.example     # Example variables file
├── .gitignore                   # Git ignore file
├── test-deployment.sh           # Automated deployment script
├── test-connectivity.sh         # Connectivity testing script
└── README.md                    # This file
```

## 🔑 Key Features

✅ **Two VPCs** with non-overlapping CIDR ranges
✅ **VPC Peering** with auto-accept enabled
✅ **Bidirectional routing** between VPCs
✅ **Security groups** configured for SSH and ICMP
✅ **Internet gateways** for public access
✅ **EC2 instances** in each VPC for testing
✅ **Comprehensive outputs** with test instructions

## 📊 Resources Created

| Resource Type | Count | Description |
|--------------|-------|-------------|
| VPC | 2 | VPC-A (10.0.0.0/16) and VPC-B (192.168.0.0/16) |
| Subnet | 2 | One public subnet in each VPC |
| Internet Gateway | 2 | One per VPC for internet access |
| Route Table | 2 | Custom route tables with peering routes |
| Security Group | 2 | Allow SSH and ICMP from peer VPC |
| EC2 Instance | 2 | t2.micro instances for testing |
| VPC Peering Connection | 1 | Connects VPC-A and VPC-B |

**Total: 17 resources**

## 🔧 Configuration Details

### VPC CIDR Blocks
- **VPC-A**: 10.0.0.0/16
- **VPC-B**: 192.168.0.0/16
- **Subnet-A**: 10.0.1.0/24 (ap-south-1a)
- **Subnet-B**: 192.168.1.0/24 (ap-south-1b)

### Security Groups

Both security groups allow:
- **SSH (port 22)** from the peer VPC CIDR
- **ICMP (ping)** from the peer VPC CIDR
- **SSH (port 22)** from 0.0.0.0/0 (for initial access)
- **All outbound traffic**

### Route Tables

Each route table includes:
- Default route (0.0.0.0/0) to Internet Gateway
- Route to peer VPC CIDR via VPC Peering Connection

## 🧪 Testing Checklist

- [ ] VPC Peering status is "active"
- [ ] Both EC2 instances are "running"
- [ ] Can SSH into EC2-A from local machine
- [ ] Can SSH into EC2-B from local machine
- [ ] Can ping EC2-B from EC2-A (using private IP)
- [ ] Can ping EC2-A from EC2-B (using private IP)
- [ ] Can SSH from EC2-A to EC2-B (using private IP)

## 🐛 Troubleshooting

### Cannot SSH into instances
- Verify security group allows SSH from your IP
- Check that instances have public IPs assigned
- Ensure key file permissions: `chmod 400 mykey.pem`
- Wait 2-3 minutes after deployment for full initialization

### Cannot ping between instances
- Verify VPC Peering connection status is "active"
- Check route tables have routes to peer VPC CIDR
- Verify security groups allow ICMP from peer VPC CIDR
- Confirm instances are in different VPCs

### Terraform errors
- Ensure AWS credentials are configured: `aws configure`
- Verify key pair "mykey" exists: `aws ec2 describe-key-pairs`
- Check AMI ID is valid for your region
- Ensure you have sufficient permissions

## 💰 Cost Estimate

Approximate AWS costs (us-east-1 region):
- **2 × EC2 t2.micro instances**: ~$0.0116/hour each = ~$0.0232/hour
- **VPC Peering data transfer**: $0.01/GB (same region)
- **Other resources**: Free tier eligible (VPC, subnets, IGW, etc.)

**Estimated total**: ~$0.025/hour or ~$18/month if left running

> ⚠️ **Important**: Remember to destroy resources when done testing!

## 🧹 Cleanup

To avoid ongoing charges:

```bash
# Destroy all resources
terraform destroy

# Confirm when prompted
```

Or use the `-auto-approve` flag to skip confirmation:

```bash
terraform destroy -auto-approve
```

## 📚 Learning Objectives

This project helps you understand:
- VPC peering concepts and configuration
- Cross-VPC networking and routing
- Security group rules for inter-VPC communication
- Terraform infrastructure as code practices
- AWS networking best practices

## 🔗 Useful Commands

```bash
# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Show current state
terraform show

# List all resources
terraform state list

# Show specific output
terraform output ec2_a_public_ip

# Refresh state
terraform refresh

# Import existing resource (example)
terraform import aws_vpc.vpc_a vpc-xxxxx
```

## 📖 Additional Resources

- [AWS VPC Peering Guide](https://docs.aws.amazon.com/vpc/latest/peering/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)

## 📝 License

This project is provided as-is for educational purposes.

## 🤝 Contributing

Feel free to submit issues or pull requests for improvements!

---

**Created with ❤️ for learning AWS networking**
