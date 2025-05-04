
# Terraform Overview and Setup

Terraform is an **Infrastructure as Code (IaC)** tool developed by HashiCorp. It allows you to define and manage your infrastructure using code instead of manually provisioning resources.

Terraform creates and manages resources on cloud platforms and other services through their **Application Programming Interface (API)**.

You write plain text files with the `.tf` extension to define the resources you need (e.g., in AWS), and Terraform provisions them for you.

There are other tools like **CloudFormation** in AWS and **Resource Manager** in Azure.

---

## Why Terraform?

Learning multiple tools can be time-consuming. Instead, learn one powerful, flexible tool—**Terraform**, which works across many cloud providers.

> Terraform is the best tool to manage infrastructure on any cloud.

---

## Core Components

### ✅ 1. Providers
Plugins that allow Terraform to manage resources on different platforms (like AWS, Azure, GCP, Kubernetes, etc.).

Examples:
- `aws` for Amazon Web Services
- `azurerm` for Microsoft Azure
- `google` for Google Cloud Platform

### ✅ 2. Resources
Infrastructure components you want to manage (e.g., EC2 instances, S3 buckets).

Defined with:
```hcl
resource "aws_instance" "example" {
  ...
}
```

### ✅ 3. Variables
Used to parameterize your code. Supports types: string, number, bool, list, map.

### ✅ 4. Outputs
Displays results after applying Terraform. Useful for displaying or passing values.

### ✅ 5. State
Terraform keeps track of managed resources in a state file (`terraform.tfstate`).

Why it's important:
- Tracks resources created/updated.
- Helps Terraform plan accurate changes.
- Required for reliable deployments.

Disadvantage: Sensitive data (passwords, secrets) may be stored in plaintext.

**Solution**: Use **remote backends** (e.g., S3 + DynamoDB) for secure state management and locking.

### ✅ 6. Modules
Collections of `.tf` files to group resources and promote **reusability**.
Check README.md in modules folder for more information about modules
---

## Terraform Architecture

```
+-----------------+
| Configuration   | (.tf files)
+-----------------+
       |
       v
+-----------------+
| Terraform Core  |
+-----------------+
       |
       v
+-----------------+
|  Providers/API  |
+-----------------+
```

---

## Terraform Workflow

```
+------------+     +-------------+     +-------------+     +-------------+
|  Write .tf | --> | terraform   | --> | terraform   | --> | terraform   |
|  files     |     | init        |     | plan        |     | apply       |
+------------+     +-------------+     +-------------+     +-------------+
                                                           |
                                                           v
                                                +---------------------+
                                                | Infrastructure is   |
                                                | provisioned/updated |
                                                +---------------------+
```

---

## Key Terraform Files

- `main.tf`: Main configuration.
- `variables.tf`: Input variables.
- `terraform.tfvars`: Variable values.
- `outputs.tf`: Output values.
- `providers.tf`: Provider configurations.

---

## Core Terraform Commands

### Initialization
```bash
terraform init
```

### Validation
```bash
terraform validate
```

### Formatting
```bash
terraform fmt
```

### Planning
```bash
terraform plan
```

### Applying
```bash
terraform apply
```

### Destroying
```bash
terraform destroy
```

---

## State Management

Terraform uses a **state file** to track real-world infrastructure.

Why?
1. Know what’s created vs. planned.
2. Helps `plan` & `apply` detect changes.
3. Without state, Terraform can't manage resources.

**Disadvantage**: Sensitive data stored in `terraform.tfstate`.

### Solution: Remote Backend
- Store state remotely (e.g., in S3).
- Enables **locking** via DynamoDB.

### State Locking
- Prevents concurrent `apply` operations.
- Avoids conflicts and corruption.

---

## Provisioners

Used to execute scripts or commands **after** resource creation.

Types:
- `file`: Upload a file to VM
- `remote-exec`: Run command on remote VM
- `local-exec`: Run command locally

---

## Workspaces

Great for managing **multiple environments** (dev, staging, prod) using the same code.

- Separate state files for each env
- No duplication of code

```bash
terraform workspace new dev
terraform workspace select dev
```

---

## Best practice

- Structure .tf files in a separate file for each service ex. EC2, VPC.
- Use modules for reusable code
- Store state file remotely

---

Now you're ready to build infrastructure on AWS using Terraform! 🚀


You will use Terraform to create resources on AWS, including:

✅ VPC & Subnets (for networking)

✅ EC2 Instances (for hosting the web app)

✅ ALB (Application Load Balancer) (for traffic distribution)

✅ Auto Scaling Group (to scale based on demand)

✅ RDS Database (for storing app data)

✅ Security Groups (to manage access)