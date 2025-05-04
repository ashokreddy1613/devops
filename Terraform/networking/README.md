# 🚀 AWS VPC Setup with Terraform

This guide walks you through the process of creating a **Virtual Private Cloud (VPC)** on AWS using **Terraform**. The configuration includes key networking components such as **public and private subnets**, **route tables**, a **NAT Gateway**, and **security groups**, forming a secure and scalable cloud infrastructure.

---

## 🧠 Key Considerations for VPC Creation with Terraform

Creating a VPC involves several important components and considerations. Let’s break down the process step by step:

---

### 1️⃣ VPC - The Network Foundation

Every AWS network architecture begins with a **VPC**, your own logically isolated network in the cloud where resources reside.

```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}
```

> 📌 This resource creates the core network structure and assigns it a CIDR block (e.g., `10.0.0.0/16`).

---

### 2️⃣ Subnets - Public & Private Segments

Subnets divide your VPC into smaller, manageable sections.

- **Public Subnet**: Connected to the internet via an Internet Gateway.  
- **Private Subnet**: No direct internet connection; used for internal services.

```hcl
resource "aws_subnet" "public" {
  # Configuration for public subnet
}

resource "aws_subnet" "private" {
  # Configuration for private subnet
}
```

> ⚠️ Each subnet **must** be associated with a specific **Availability Zone (AZ)**.

---

### 3️⃣ Internet Gateway (IGW) - External Access

The Internet Gateway provides internet access for instances in **public subnets**.

```hcl
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}
```

Attach the IGW to the **public route table** to route internet-bound traffic (e.g., `0.0.0.0/0`).

---

### 4️⃣ NAT Gateway - Secure Outbound for Private Subnets

The NAT Gateway allows instances in **private subnets** to access the internet for updates or downloads, while preventing inbound connections.

```hcl
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}
```

Deploy the NAT Gateway in a **public subnet** and configure the **private route table** to direct internet-bound traffic to it.

---

### 5️⃣ Route Tables - Network Traffic Control

Route tables define how traffic moves within the VPC. Each subnet is associated with one route table.

- **Public Route Table**: Routes internet-bound traffic through the IGW.
- **Private Route Table**: Routes internet-bound traffic through the NAT Gateway.

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}
```

---

## ✅ Conclusion

Terraform empowers you to manage AWS infrastructure as code. This modular approach using Terraform allows for scalable, reusable, and secure VPC setups that can be tailored to various environments like development, staging, and production.
