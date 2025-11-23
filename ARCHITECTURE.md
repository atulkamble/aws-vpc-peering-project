# AWS VPC Peering Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          AWS Cloud (ap-south-1)                      │
│                                                                      │
│  ┌───────────────────────────────┐  ┌───────────────────────────┐  │
│  │  VPC-A (10.0.0.0/16)          │  │  VPC-B (192.168.0.0/16)   │  │
│  │                               │  │                           │  │
│  │  ┌─────────────────────────┐  │  │  ┌─────────────────────┐ │  │
│  │  │ Internet Gateway (IGW-A)│  │  │  │Internet Gateway     │ │  │
│  │  └──────────┬──────────────┘  │  │  │    (IGW-B)          │ │  │
│  │             │                  │  │  └──────┬──────────────┘ │  │
│  │  ┌──────────▼──────────────┐  │  │  ┌──────▼──────────────┐ │  │
│  │  │  Route Table (RT-A)     │  │  │  │ Route Table (RT-B)  │ │  │
│  │  │  • 0.0.0.0/0 → IGW-A    │  │  │  │ • 0.0.0.0/0 → IGW-B │ │  │
│  │  │  • 192.168.0.0/16 → PCX │  │  │  │ • 10.0.0.0/16 → PCX │ │  │
│  │  └──────────┬──────────────┘  │  │  └──────┬──────────────┘ │  │
│  │             │                  │  │         │                │  │
│  │  ┌──────────▼──────────────┐  │  │  ┌──────▼──────────────┐ │  │
│  │  │  Subnet-A               │  │  │  │ Subnet-B            │ │  │
│  │  │  10.0.1.0/24            │  │  │  │ 192.168.1.0/24      │ │  │
│  │  │  (ap-south-1a)          │  │  │  │ (ap-south-1b)       │ │  │
│  │  │                         │  │  │  │                     │ │  │
│  │  │  ┌──────────────────┐   │  │  │  │ ┌──────────────┐   │ │  │
│  │  │  │ EC2-A (t2.micro) │   │  │  │  │ │EC2-B(t2.micro)│  │ │  │
│  │  │  │ Private: 10.0.1.x│   │  │  │  │ │Private:      │   │ │  │
│  │  │  │ Public: x.x.x.x  │   │  │  │  │ │192.168.1.x   │   │ │  │
│  │  │  │                  │   │  │  │  │ │Public: x.x.x │   │ │  │
│  │  │  │ ┌──────────────┐ │   │  │  │  │ │┌───────────┐ │   │ │  │
│  │  │  │ │Security Group│ │   │  │  │  │ ││Security   │ │   │ │  │
│  │  │  │ │• SSH from    │ │   │  │  │  │ ││Group      │ │   │ │  │
│  │  │  │ │  VPC-B       │ │   │  │  │  │ ││• SSH from │ │   │ │  │
│  │  │  │ │• ICMP from   │ │   │  │  │  │ ││  VPC-A    │ │   │ │  │
│  │  │  │ │  VPC-B       │ │   │  │  │  │ ││• ICMP from│ │   │ │  │
│  │  │  │ │• SSH from    │ │   │  │  │  │ ││  VPC-A    │ │   │ │  │
│  │  │  │ │  0.0.0.0/0   │ │   │  │  │  │ ││• SSH from │ │   │ │  │
│  │  │  │ └──────────────┘ │   │  │  │  │ ││  0.0.0.0/0│ │   │ │  │
│  │  │  └──────────────────┘   │  │  │  │ │└───────────┘ │   │ │  │
│  │  └─────────────────────────┘  │  │  │ └──────────────┘   │ │  │
│  └───────────────┬───────────────┘  │  └────────┬───────────┘ │  │
│                  │                  │           │             │  │
│                  │  ┌───────────────▼───────────▼───────┐     │  │
│                  └──┤ VPC Peering Connection (PCX)       │─────┘  │
│                     │ Status: Active                     │        │
│                     │ Auto-accept: Enabled               │        │
│                     └────────────────────────────────────┘        │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

                              Internet
                                 ▲
                                 │
                ┌────────────────┴────────────────┐
                │                                 │
          SSH via Public IP              SSH via Public IP
         (Initial Access)                (Initial Access)
```

## Traffic Flow

### 1. Internet → EC2 Instances
```
Internet → Internet Gateway → Route Table → Subnet → EC2 Instance
```

### 2. EC2-A → EC2-B (via VPC Peering)
```
EC2-A (10.0.1.x) 
  → Subnet-A 
  → RT-A (192.168.0.0/16 → PCX) 
  → VPC Peering Connection 
  → RT-B (10.0.0.0/16 → PCX) 
  → Subnet-B 
  → EC2-B (192.168.1.x)
```

### 3. EC2-B → EC2-A (via VPC Peering)
```
EC2-B (192.168.1.x) 
  → Subnet-B 
  → RT-B (10.0.0.0/16 → PCX) 
  → VPC Peering Connection 
  → RT-A (192.168.0.0/16 → PCX) 
  → Subnet-A 
  → EC2-A (10.0.1.x)
```

## Key Configuration Points

### Route Tables
- **RT-A**: Routes 192.168.0.0/16 traffic to VPC Peering Connection
- **RT-B**: Routes 10.0.0.0/16 traffic to VPC Peering Connection

### Security Groups
- **SG-A**: Allows SSH (22) and ICMP from VPC-B CIDR (192.168.0.0/16)
- **SG-B**: Allows SSH (22) and ICMP from VPC-A CIDR (10.0.0.0/16)
- Both allow SSH from internet (0.0.0.0/0) for initial access

### VPC Peering
- **Type**: Same region peering
- **Auto-accept**: Enabled (both VPCs in same account)
- **DNS resolution**: Enabled via VPC DNS settings

## Testing Commands

```bash
# SSH to EC2-A
ssh -i mykey.pem ec2-user@<EC2_A_PUBLIC_IP>

# From EC2-A, ping EC2-B
ping 192.168.1.x

# From EC2-A, SSH to EC2-B
ssh ec2-user@192.168.1.x
```

## Resource Count: 17

| Type | Resource | Count |
|------|----------|-------|
| Network | VPC | 2 |
| Network | Subnet | 2 |
| Network | Internet Gateway | 2 |
| Network | Route Table | 2 |
| Network | Route Table Association | 2 |
| Network | Route (Peering) | 2 |
| Network | VPC Peering Connection | 1 |
| Security | Security Group | 2 |
| Compute | EC2 Instance | 2 |
| **Total** | | **17** |
