# Terraform Interview Questions and Answers

## 📁 Core Concepts

### 1. What is Terraform and how do you use it in your project?
Terraform is an Infrastructure as Code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. It uses a declarative configuration language called HCL (HashiCorp Configuration Language).

Key uses in a project:
- Define infrastructure in code
- Version control infrastructure changes
- Automate infrastructure deployment
- Ensure consistency across environments
- Manage multiple cloud providers
- Enable collaboration through code review
- Implement infrastructure testing
- Support disaster recovery

### 2. What is Terraform state file?
The Terraform state file is a JSON file that maps real-world resources to your configuration. It serves several critical purposes:

- Maps resources to configuration
- Tracks resource dependencies
- Stores resource metadata
- Improves performance for large infrastructures
- Enables resource tracking across team members
- Facilitates resource updates and deletions

### 3. What happens if the Terraform state file is accidentally deleted?
If the Terraform state file is deleted:
1. Terraform loses track of managed resources
2. Cannot determine existing resources in the cloud
3. May attempt to recreate all resources
4. Could lead to duplicate resources
5. May cause orphaned resources
6. Requires manual intervention to recover

### 4. How do you manage Terraform state file?
Best practices for state management:

1. Use remote state storage:
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/state/file"
    region = "us-west-2"
    dynamodb_table = "terraform-lock"
  }
}
```

2. Enable state locking
3. Implement state file encryption
4. Use state file versioning
5. Implement backup strategies
6. Use workspaces for environment separation

### 5. How do you update the statefile from local to S3 bucket?
To migrate state to S3:

1. Configure S3 backend:
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/state/file"
    region = "us-west-2"
    dynamodb_table = "terraform-lock"
  }
}
```

2. Initialize the new backend:
```bash
terraform init -migrate-state
```

If state is lost:
1. Use `terraform import` to reimport resources
2. Recreate state from existing infrastructure
3. Use backup if available
4. Document and recreate if necessary

### 6. What is the lock file in Terraform?
The lock file (`.terraform.lock.hcl`) is used to:
- Lock provider versions
- Ensure consistent provider versions across team
- Prevent version conflicts
- Track provider checksums
- Enable reproducible builds

### 7. How do you store the data in the state file locally or remotely?
State can be stored in two ways:

1. Locally (default):
```hcl
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}
```

2. Remotely (S3 example):
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/state/file"
    region = "us-west-2"
  }
}
```

### 8. What block do you use while storing the state file?
Use the `terraform` block with `backend` configuration:
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/state/file"
    region = "us-west-2"
  }
}
```

## ⚙️ Commands and Operations

### 1. What is the purpose of terraform init, plan, and apply?
- `terraform init`: 
  - Initializes a working directory
  - Downloads providers and modules
  - Sets up backend configuration
  - Prepares for Terraform operations

- `terraform plan`:
  - Creates an execution plan
  - Shows what actions will be taken
  - Validates configuration
  - Checks for errors

- `terraform apply`:
  - Applies the changes
  - Creates/updates infrastructure
  - Updates state file
  - Handles resource dependencies

### 2. What is the command for auto approval in Terraform?
```bash
terraform apply -auto-approve
```

### 3. How do you validate a Terraform file if provisioning fails?
1. Use `terraform validate` to check syntax
2. Use `terraform plan` to preview changes
3. Check logs and error messages
4. Use `terraform state list` to verify state
5. Use `terraform show` to inspect current state

### 4. What happens to the Terraform state file if someone deletes resources manually from cloud?
The state file becomes out of sync. To fix:
1. Run `terraform plan` to see the drift
2. Use `terraform import` to reimport the resource
3. Or use `terraform state rm` to remove the resource from state
4. Then run `terraform apply` to reconcile the state

### 5. Suppose I have given one command in null_resource, it should run every time. What is the behavior?
Use the `triggers` block with a timestamp:
```hcl
resource "null_resource" "example" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = "your-command-here"
  }
}
```

## 🧱 Resources and Provisioning

### 1. Have you written any Terraform code to build a VM?
Yes, here's an example for AWS EC2:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "example-instance"
  }
}
```

### 2. Write a Terraform code to create multiple S3 buckets
```hcl
variable "bucket_names" {
  type = list(string)
  default = ["bucket1", "bucket2", "bucket3"]
}

resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  
  bucket = each.value
  
  tags = {
    Name = each.value
  }
}
```

### 3. Write a sample Terraform resource file
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "main"
  }
}
```

### 4. Write Terraform code to provision an EC2 instance with a security group allowing only SSH access
```hcl
resource "aws_security_group" "ssh" {
  name        = "ssh-access"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "example-instance"
  }
}
```

### 5. Write a Terraform code to create VPC, subnet, EC2, S3 bucket
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "main"
  }
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  
  tags = {
    Name = "example-instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"
  
  tags = {
    Name = "example-bucket"
  }
}
```

### 6. Can you write a Terraform file to provision an EC2 instance in a public subnet?
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "public"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  
  tags = {
    Name = "example-instance"
  }
}
```

## 🔗 Modules and Environments

### 1. What is a Terraform module?
A Terraform module is a reusable, self-contained package of Terraform configurations that manages a specific set of resources. Modules help:
- Organize code
- Reuse infrastructure
- Maintain consistency
- Share infrastructure patterns
- Encapsulate complexity
- Enable versioning

### 2. How do you manage multiple environment configurations in Terraform?
1. Use workspaces
2. Use separate state files
3. Use variable files
4. Use modules with environment-specific variables
5. Use remote state with different keys

Example:
```hcl
# terraform.tfvars for dev
environment = "dev"
instance_type = "t2.micro"

# terraform.tfvars for prod
environment = "prod"
instance_type = "t3.large"
```

### 3. Best practices to structure repos and pipelines in a large DevOps project?
1. Use a modular structure
2. Separate environments
3. Use remote state
4. Implement CI/CD
5. Use version control
6. Implement testing
7. Use consistent naming
8. Document everything

### 4. How do you scale a Terraform pipeline that takes 25+ mins?
1. Use parallel execution
2. Implement caching
3. Use remote state
4. Optimize provider usage
5. Use targeted applies
6. Implement state locking
7. Use workspaces
8. Optimize resource dependencies

## 🧩 Provisioners and Logic

### 1. What are the provisioners available in Terraform and can you explain the use cases?
1. `local-exec`: Run local commands
2. `remote-exec`: Run commands on remote resource
3. `file`: Copy files to remote resource
4. `chef`: Chef provisioner
5. `puppet`: Puppet provisioner
6. `salt-masterless`: Salt provisioner

### 2. What is the difference between a map and object in Terraform?
- Map: Key-value pairs where all values must be of the same type
- Object: Key-value pairs where values can be of different types

Example:
```hcl
# Map
variable "map_example" {
  type = map(string)
  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

# Object
variable "object_example" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "John"
    age  = 30
  }
}
```

### 3. What is the difference between list and string in Terraform?
- List: Ordered collection of values of the same type
- String: Single text value

Example:
```hcl
# List
variable "list_example" {
  type = list(string)
  default = ["item1", "item2", "item3"]
}

# String
variable "string_example" {
  type = string
  default = "single value"
}
```

## 🛡️ Security & IAM Integration

### 1. How do you provide AWS access to new users using Terraform?
```hcl
resource "aws_iam_user" "new_user" {
  name = "new-user"
}

resource "aws_iam_user_policy" "user_policy" {
  name = "user-policy"
  user = aws_iam_user.new_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

### 2. How do you enforce Azure Policies using Terraform at scale?
1. Use Azure Policy assignments
2. Use policy initiatives
3. Use policy definitions
4. Use policy exemptions
5. Use policy remediation

Example:
```hcl
resource "azurerm_policy_assignment" "example" {
  name                 = "example-policy"
  scope                = azurerm_resource_group.example.id
  policy_definition_id = azurerm_policy_definition.example.id
  description          = "Policy Assignment created via Terraform"
  display_name         = "Example Policy Assignment"
}
```

## 🎯 Advanced Scenarios and Best Practices

### 1. Zero-Downtime Deployment
**Scenario:** Update EC2 instance's AMI ID without downtime.

**Solution:**
```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

**Key Points:**
- Use `create_before_destroy` lifecycle rule
- Ensures new instance is created before old one is deleted
- Alternative: Use Auto Scaling Group with rolling updates

### 2. Cross-Region Infrastructure
**Scenario:** Deploy S3 bucket in us-east-1 and EC2 in ap-south-1.

**Solution:**
```hcl
provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-south"
  region = "ap-south-1"
}

resource "aws_s3_bucket" "example" {
  provider = aws.us-east
  bucket   = "my-bucket-us-east"
}

resource "aws_instance" "example" {
  provider      = aws.ap-south
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

### 3. Handling Infrastructure Drift
**Scenario:** Manual changes made to Terraform-managed infrastructure.

**Solution:**
1. Detect drift:
```bash
terraform plan -refresh-only
```

2. Re-import modified resources:
```bash
terraform import aws_instance.example i-1234567890abcdef0
```

3. Apply to restore configuration:
```bash
terraform apply
```

### 4. Security Policy Enforcement
**Scenario:** Restrict EC2 instance types to control costs.

**Solution:**
```hcl
variable "instance_type" {
  description = "AWS EC2 instance type"
  type        = string

  validation {
    condition     = contains(["t2.micro"], var.instance_type)
    error_message = "Only t2.micro instance type is allowed."
  }
}
```

### 5. Blue-Green Deployment
**Scenario:** Implement blue-green deployment for Auto Scaling Group.

**Solution:**
```hcl
resource "aws_launch_template" "blue" {
  name = "blue-template"
  image_id = var.ami_blue
}

resource "aws_launch_template" "green" {
  name = "green-template"
  image_id = var.ami_green
}

resource "aws_autoscaling_group" "blue" {
  launch_template {
    id = aws_launch_template.blue.id
  }
}

resource "aws_autoscaling_group" "green" {
  launch_template {
    id = aws_launch_template.green.id
  }
}

resource "aws_lb_listener_rule" "switch" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  conditions {
    field  = "path-pattern"
    values = ["*"]
  }
  actions {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}
```

### 6. API Rate Limit Handling
**Scenario:** Creating 100+ AWS resources with API rate limits.

**Solution:**
1. Configure retry settings:
```hcl
provider "aws" {
  region = "us-east-1"
  max_retries = 5
}
```

2. Stagger resource creation:
```hcl
resource "aws_instance" "one" {
  ami = "ami-123456"
}

resource "aws_instance" "two" {
  ami       = "ami-123456"
  depends_on = [aws_instance.one]
}
```

### 7. Resource Protection
**Scenario:** Prevent accidental deletion of production RDS.

**Solution:**
```hcl
resource "aws_db_instance" "production_db" {
  identifier = "prod-db"
  engine     = "mysql"
  instance_class = "db.t3.large"

  lifecycle {
    prevent_destroy = true
  }
}
```

### 8. Multi-Account Management
**Scenario:** Managing multiple AWS accounts (Dev, QA, Prod).

**Solution:**
```hcl
provider "aws" {
  region = "us-east-1"
  alias  = terraform.workspace
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-${terraform.workspace}"
}
```

### 9. State Lock Resolution
**Scenario:** Resolving locked Terraform state.

**Solution:**
1. Force unlock:
```bash
terraform force-unlock <LOCK_ID>
```

2. Verify state:
```bash
terraform state list
terraform state show
```

### 10. Deployment Rollback
**Scenario:** Rolling back failed Terraform deployment.

**Solution:**
1. Restore previous state:
```bash
terraform state pull > backup.tfstate
terraform state push backup.tfstate
```

2. Revert code and reapply:
```bash
terraform apply
```

### 11. Dynamic Resource Scaling
**Scenario:** Different EC2 instance types per environment.

**Solution:**
```hcl
variable "instance_type_map" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod = "t3.large"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = var.instance_type_map[var.environment]
}
```

### 12. Secret Management
**Scenario:** Securely managing AWS credentials.

**Solution:**
```hcl
data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = "my-db-creds"
}

resource "aws_db_instance" "db" {
  username = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["password"]
}
```

### 13. State Management
**Scenario:** Managing large Terraform state files.

**Solution:**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
```

### 14. EKS Auto-Scaling
**Scenario:** Auto-scaling EKS worker nodes.

**Solution:**
```hcl
resource "aws_autoscaling_group" "eks_nodes" {
  min_size         = 2
  max_size         = 10
  desired_capacity = 3

  tag {
    key                 = "kubernetes.io/cluster/my-cluster"
    value               = "owned"
    propagate_at_launch = true
  }
}
```

### 15. Resource Recreation Prevention
**Scenario:** Preventing EC2 instance recreation.

**Solution:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = [instance_type]
  }
}
```

**Manual Update Process:**
1. Update instance outside Terraform
2. Import changes:
```bash
terraform import aws_instance.example i-1234567890abcdef
```
