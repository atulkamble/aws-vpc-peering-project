# 🚀 **AWS VPC Peering Project**

**Goal:** Create two VPCs → peer them → allow traffic → test connectivity using EC2 instances.

---

# 🏗 **1. Architecture**

```
VPC-A (10.0.0.0/16)
 └── Subnet-A (10.0.1.0/24)
      └── EC2-A (Private/Public)

VPC-B (192.168.0.0/16)
 └── Subnet-B (192.168.1.0/24)
      └── EC2-B (Private/Public)

VPC Peering Connection
   (pcx-XXXX between VPC-A ↔ VPC-B)
Routing + SG rules for communication
```

---

# 🔑 **2. Key Concepts to Remember**

* VPC Peering is **one-to-one** (not transitive).
* CIDR ranges must **NOT overlap**.
* You must update **Route Tables on BOTH VPCs**.
* Security Groups must allow inbound traffic from the **other VPC CIDR**.
* Peering works within:

  * Same region (easy)
  * Cross-region (also possible)
* No edge-to-edge routing (cannot use Internet/NAT to reach other VPC).

---

# 🛠 **3. Terraform Project (Complete Code)**

## 📁 Folder Structure

```
vpc-peering-project/
 ├── main.tf
 ├── variables.tf
 ├── outputs.tf
```

---

## 📌 **main.tf**

```tf
provider "aws" {
  region = "ap-south-1"
}

# -----------------------------
# VPC A
# -----------------------------
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id
}

resource "aws_route_table_association" "rt_assoc_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}

# EC2 in VPC A
resource "aws_instance" "ec2_a" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  associate_public_ip_address = true
  key_name      = "mykey"
}

# -----------------------------
# VPC B
# -----------------------------
resource "aws_vpc" "vpc_b" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-south-1b"
}

resource "aws_internet_gateway" "igw_b" {
  vpc_id = aws_vpc.vpc_b.id
}

resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id
}

resource "aws_route_table_association" "rt_assoc_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}

# EC2 in VPC B
resource "aws_instance" "ec2_b" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id
  associate_public_ip_address = true
  key_name      = "mykey"
}

# -----------------------------
# VPC PEERING
# -----------------------------
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_b.id
  auto_accept   = true
}

# -----------------------------
# ROUTES
# -----------------------------
resource "aws_route" "route_a_to_b" {
  route_table_id         = aws_route_table.rt_a.id
  destination_cidr_block = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_b_to_a" {
  route_table_id         = aws_route_table.rt_b.id
  destination_cidr_block = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# -----------------------------
# SECURITY GROUPS
# -----------------------------
resource "aws_security_group" "sg_a" {
  vpc_id = aws_vpc.vpc_a.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_b.cidr_block]
  }
}

resource "aws_security_group" "sg_b" {
  vpc_id = aws_vpc.vpc_b.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_a.cidr_block]
  }
}
```

---

## 📌 **outputs.tf**

```tf
output "ec2_a_ip" {
  value = aws_instance.ec2_a.public_ip
}

output "ec2_b_ip" {
  value = aws_instance.ec2_b.public_ip
}

output "peering_id" {
  value = aws_vpc_peering_connection.peer.id
}
```

---

# 🧪 **4. Testing the Peering**

### **STEP 1: SSH into EC2-A**

```bash
ssh -i mykey.pem ec2-user@<EC2_A_PUBLIC_IP>
```

### **STEP 2: Ping EC2-B Private IP**

```bash
ping 192.168.1.10
```

### **STEP 3: SSH from EC2-A → EC2-B**

```bash
ssh ec2-user@192.168.1.10
```

✔ If it works → peering is successful.
❌ If not, check:

* Route tables
* SG rules
* Correct CIDR ranges
* VPC Peering status

---

# 🧾 **5. AWS CLI Commands (Optional)**

### Create Peering

```bash
aws ec2 create-vpc-peering-connection \
  --vpc-id vpc-aaa \
  --peer-vpc-id vpc-bbb
```

### Accept Peering

```bash
aws ec2 accept-vpc-peering-connection \
  --vpc-peering-connection-id pcx-12345
```

### Add Route

```bash
aws ec2 create-route \
  --route-table-id rtb-123 \
  --destination-cidr-block 192.168.0.0/16 \
  --vpc-peering-connection-id pcx-12345
```

---

# 📦 **6. README for GitHub (Copy-Paste)**

```
# AWS VPC Peering Project

## Features
- 2 VPCs with non-overlapping CIDRs
- Public subnets + EC2 instances
- VPC Peering connection
- Route tables updates
- SG rules for allowed traffic
- Complete Terraform IaC

## Commands
terraform init  
terraform plan  
terraform apply
```

---

