#!/bin/bash
# Quick Reference - AWS VPC Peering Project

cat << 'EOF'

╔══════════════════════════════════════════════════════════════╗
║          AWS VPC PEERING PROJECT - QUICK REFERENCE           ║
╚══════════════════════════════════════════════════════════════╝

📋 PROJECT FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Core Terraform:
  └─ main.tf              Infrastructure definition
  └─ variables.tf         Configuration variables  
  └─ outputs.tf           Output definitions
  └─ terraform.tfvars.example  Variable template

 Scripts:
  └─ test-deployment.sh   Automated deployment
  └─ test-connectivity.sh Connectivity testing

 Documentation:
  └─ README.md            Project overview
  └─ DEPLOYMENT_GUIDE.md  Detailed guide
  └─ ARCHITECTURE.md      Architecture diagrams
  └─ PROJECT_STATUS.md    Implementation status

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 QUICK START
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. Deploy:
    ./test-deployment.sh

 2. Test:
    ./test-connectivity.sh

 3. Cleanup:
    terraform destroy

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 RESOURCES TO BE CREATED (17 total)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  2 × VPCs
  2 × Subnets
  2 × Internet Gateways
  2 × Route Tables
  2 × Route Table Associations
  2 × Routes (for peering)
  2 × Security Groups
  2 × EC2 Instances (t2.micro)
  1 × VPC Peering Connection

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 MANUAL COMMANDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Initialize:
  $ terraform init

 Validate:
  $ terraform validate

 Plan:
  $ terraform plan

 Apply:
  $ terraform apply

 Show outputs:
  $ terraform output

 Destroy:
  $ terraform destroy

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧪 TESTING CONNECTIVITY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. Get IPs:
    $ terraform output

 2. SSH to EC2-A:
    $ ssh -i mykey.pem ec2-user@<EC2_A_PUBLIC_IP>

 3. Ping EC2-B from EC2-A:
    $ ping <EC2_B_PRIVATE_IP>

 4. SSH from EC2-A to EC2-B:
    $ ssh ec2-user@<EC2_B_PRIVATE_IP>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚙️  CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 VPC-A:          10.0.0.0/16
 Subnet-A:       10.0.1.0/24 (ap-south-1a)
 
 VPC-B:          192.168.0.0/16
 Subnet-B:       192.168.1.0/24 (ap-south-1b)
 
 Instance Type:  t2.micro
 Key Pair:       mykey
 Region:         ap-south-1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 TROUBLESHOOTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Can't SSH:
  ✓ Check AWS credentials: aws configure
  ✓ Verify key exists: aws ec2 describe-key-pairs
  ✓ Fix permissions: chmod 400 mykey.pem
  ✓ Wait 2-3 minutes after deployment

 Can't ping between VPCs:
  ✓ Check peering status: aws ec2 describe-vpc-peering-connections
  ✓ Verify route tables have correct routes
  ✓ Check security groups allow ICMP from peer VPC
  ✓ Confirm instances are running

 Terraform errors:
  ✓ Run: terraform validate
  ✓ Check: AWS credentials configured
  ✓ Verify: Key pair exists in region

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💰 COST ESTIMATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  EC2 (2 × t2.micro):  ~$0.023/hour
  Data transfer:       $0.01/GB
  Other resources:     Free tier eligible

  Total: ~$18/month if left running

  ⚠️  Remember to run 'terraform destroy' when done!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 DOCUMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 DEPLOYMENT_GUIDE.md  - Complete deployment instructions
 ARCHITECTURE.md      - Architecture diagrams & flow
 PROJECT_STATUS.md    - Implementation summary
 README.md            - Original project overview

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓ Terraform initialized
  ✓ Configuration validated
  ✓ All files formatted
  ✓ Test scripts executable
  ✓ Ready for deployment!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
