## 📦 Why Use Variables and Modules?

While you can define all your resources in a single `main.tf` file, this approach quickly becomes **messy and unmanageable**, especially across multiple environments like **dev**, **staging**, and **production**.

To make your code **flexible, reusable, maintainable**, and clean, use **variables** and **modules**.

---

## 🧩 Variables

Variables parameterize your infrastructure code—removing hardcoded values and increasing reusability.

### 🔁 Benefits:
- Easily switch between environments (dev, staging, prod)
- Pass values dynamically without editing `.tf` files

### 1️⃣ Define Variables

In `variables.tf`:

```hcl
variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### 2️⃣ Use Variables

In your `main.tf`:

```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI
  instance_type = var.instance_type

  tags = {
    Name = "TerraformExample"
  }
}
```

---

## 📁 Modules

Modules in Terraform are like **functions in programming**—a group of reusable infrastructure code.

### 🛠 Structure: `modules/ec2/`

#### `variables.tf`
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type = string
}
```

#### `main.tf`
```hcl
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "ModularEC2"
  }
}
```

#### `outputs.tf`
```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

### ✅ Use the Module in Root Configuration

In your root `main.tf`:

```hcl
module "ec2_instance" {
  source        = "./modules/ec2"
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}
```

---

### 🎯 Benefits of Using Modules

1. **Reusability** – Use the same code across environments and projects  
2. **Maintainability** – Easier to manage and update infrastructure  
3. **Separation of Concerns** – Organize resources cleanly  
4. **Testing & Versioning** – Modular code is easier to test and version  
