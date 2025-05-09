# AWS Interview Answers

## 🧠 General AWS Knowledge

### How comfortable with AWS and how much do you rate yourself out of 5?
I am very comfortable with AWS and would rate myself 5/5. I have extensive experience working with various AWS services and implementing cloud solutions.

### What are the services you have used in AWS?
I have used a wide range of AWS services including EC2, S3, VPC, IAM, Lambda, CloudWatch, Route 53, ECS, EKS, Fargate, and many more.

### Explain how you did your cloud migration.
Our cloud migration involved a phased approach:
1. Assessment of existing infrastructure and applications
2. Planning and designing the target AWS architecture
3. Setting up the AWS environment (VPC, security groups, IAM roles)
4. Migrating data and applications using AWS tools like AWS Database Migration Service and AWS Server Migration Service
5. Testing and validation of the migrated applications
6. Cutover to the new environment
7. Post-migration optimization and monitoring

### How do you manage AWS + Azure using a single DevOps process with focus on security & cost?
We use a multi-cloud strategy with a unified DevOps process:
- Infrastructure as Code (IaC) using Terraform to manage resources across both clouds
- CI/CD pipelines that deploy to both AWS and Azure
- Centralized monitoring and logging using tools like CloudWatch and Azure Monitor
- Security policies and compliance checks implemented across both platforms
- Cost management tools to monitor and optimize spending in both clouds

### How did you perform cost optimization in AWS?
Cost optimization strategies include:
- Right-sizing EC2 instances
- Using Reserved Instances and Savings Plans
- Implementing auto-scaling
- Using Spot Instances for non-critical workloads
- Optimizing storage (S3 lifecycle policies, EBS volume management)
- Regular review of unused resources
- Using AWS Cost Explorer and Budgets for monitoring

### If U want to design an infra for high scalability, how did u do that?
For high scalability, we implemented:
- Auto-scaling groups for EC2 instances
- Load balancers (ALB/NLB) for traffic distribution
- Microservices architecture
- Serverless components (Lambda, Fargate)
- Caching solutions (ElastiCache)
- Database scaling (RDS read replicas, DynamoDB)
- CDN for static content delivery

## 🖥️ EC2

### What is an EC2 instance?
An EC2 (Elastic Compute Cloud) instance is a virtual server in AWS's cloud. It allows you to run applications on the AWS infrastructure.

### How do you create an EC2 instance via Terraform?
Here's a basic example of creating an EC2 instance using Terraform:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "example-instance"
  }
}
```

### How do you assign a custom security group and user data in EC2 via Terraform?
```hcl
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /tmp/hello.txt
              EOF
  tags = {
    Name = "example-instance"
  }
}
```

### I have created EC2 instance A, how to create B without deleting A?
You can create a new EC2 instance B by using a different resource name in Terraform or by creating a new instance in the AWS Console without affecting instance A.

### EC2 instance is unreachable, not a SG issue – how do you troubleshoot?
Troubleshooting steps:
1. Check if the instance is running
2. Verify the instance's public IP/DNS
3. Check the instance's system logs
4. Verify the instance's network configuration
5. Check if the instance's user data script completed successfully
6. Verify the instance's IAM role and permissions
7. Check if the instance's EBS volume is attached and healthy

### How to login to VM with private IP?
To login to a VM with a private IP, you need to:
1. Use a bastion host or VPN to access the private network
2. SSH into the bastion host
3. From the bastion host, SSH into the target VM using its private IP

### I'm an admin but I don't have access to the S3 bucket → IAM permission boundary.
This could be due to:
- IAM permission boundaries limiting your access
- Resource-based policies on the S3 bucket
- Organization-level policies
- Service control policies (SCPs)

## ☁️ S3

### Difference between S3 and EBS.
- S3 is object storage, while EBS is block storage
- S3 is highly durable and available, while EBS is attached to EC2 instances
- S3 is used for storing files and backups, while EBS is used for EC2 instance storage

### How do you maintain the lifecycle of an S3 bucket?
S3 lifecycle rules can be configured to:
- Transition objects between storage classes
- Expire objects after a certain period
- Delete incomplete multipart uploads
- Archive objects to Glacier

### What is the purpose of creating S3 bucket policies?
S3 bucket policies are used to:
- Control access to the bucket and its objects
- Define who can perform which actions
- Set up cross-account access
- Enforce encryption requirements

### An S3 bucket was made public by mistake. How do you secure and audit it?
Steps to secure and audit a public S3 bucket:
1. Remove public access settings
2. Review and update bucket policies
3. Enable versioning
4. Enable server-side encryption
5. Set up CloudTrail to audit access
6. Use AWS Config to monitor bucket settings
7. Review and remove any public ACLs

### Can we create AWS backup using shell scripting?
Yes, you can create AWS backups using the AWS CLI in shell scripts. For example:
```bash
aws backup create-backup-vault --backup-vault-name MyBackupVault
aws backup start-backup-job --backup-vault-name MyBackupVault --resource-arn arn:aws:ec2:region:account-id:instance/instance-id
```

### Storing logs in S3 bucket – how do you track IPs?
You can track IPs in S3 logs by:
- Enabling S3 access logging
- Using CloudTrail to log API calls
- Analyzing logs using Athena or CloudWatch Logs
- Setting up alerts for suspicious IPs

### Sending log files from EC2 to S3 – what are the steps?
Steps to send logs from EC2 to S3:
1. Create an IAM role with S3 write permissions
2. Attach the role to the EC2 instance
3. Use AWS CLI or SDK to upload logs to S3
4. Set up a cron job or use CloudWatch Logs agent to automate the process

## 🕸️ VPC & Networking

### What is VPC peering?
VPC peering is a networking connection between two VPCs that enables you to route traffic between them using private IP addresses.

### What is the difference between subnet and NACL?
- Subnets are segments of a VPC's IP address range
- NACLs (Network Access Control Lists) are stateless firewalls that control traffic at the subnet level

### Difference between NAT Gateway and Internet Gateway.
- Internet Gateway allows resources in a VPC to connect to the internet
- NAT Gateway allows resources in a private subnet to connect to the internet while maintaining their private IP

### Can you avoid the specific port traffic using SGs?
Yes, you can use Security Groups to allow or deny traffic on specific ports.

### Difference between SGs and NACLs.
- Security Groups are stateful and operate at the instance level
- NACLs are stateless and operate at the subnet level

### Where do you use firewalls, SGs, and NACLs?
- Firewalls: On-premises or in the cloud for network security
- Security Groups: For instance-level security in AWS
- NACLs: For subnet-level security in AWS

### What are the security parameters for EC2 in production?
Security parameters for EC2 in production include:
- Using security groups to control traffic
- Implementing IAM roles
- Enabling encryption for EBS volumes
- Regular security updates and patches
- Monitoring and logging

### Transit Gateway – what is it and why use it?
Transit Gateway is a service that enables you to connect multiple VPCs and on-premises networks through a single gateway. It simplifies network architecture and reduces operational complexity.

### How do you connect private subnet to the internet?
To connect a private subnet to the internet, you need:
1. A NAT Gateway in a public subnet
2. Route tables configured to route traffic from the private subnet to the NAT Gateway

### How do you connect from AWS to on-prem servers?
You can connect AWS to on-prem servers using:
- VPN connection
- AWS Direct Connect
- Transit Gateway

### Is it possible to create NAT gateway in private subnet?
No, NAT Gateways must be created in a public subnet.

### VPC Flow Logs – how do you track the IPs hitting the VPC?
VPC Flow Logs capture information about IP traffic going to and from network interfaces in your VPC. You can analyze these logs using CloudWatch Logs or Athena.

### Two AWS accounts – access token in B from EC2 in A – how?
To access resources in Account B from an EC2 instance in Account A:
1. Create an IAM role in Account B with the necessary permissions
2. Assume the role from Account A using AWS STS
3. Use the temporary credentials to access resources in Account B

## ⚙️ IAM & Security

### Difference between IAM Users and IAM Roles.
- IAM Users are identities that can be used to interact with AWS services
- IAM Roles are identities that can be assumed by users, applications, or services

### What are IAM policies?
IAM policies are documents that define permissions for AWS resources. They specify what actions are allowed or denied on which resources.

### How do you provide AWS access to new users?
To provide AWS access to new users:
1. Create an IAM user
2. Assign appropriate permissions using IAM policies
3. Generate access keys or set up password for console access

### What are the best password security practices?
Best password security practices include:
- Using strong, unique passwords
- Enabling MFA
- Regularly rotating passwords
- Using password policies to enforce complexity

### How do you implement best security policies on AWS?
Implementing best security policies on AWS involves:
- Using IAM roles and policies
- Enabling encryption
- Setting up security groups and NACLs
- Regular security audits and compliance checks

## 🧠 Lambda

### What is Lambda function?
AWS Lambda is a serverless compute service that lets you run code without provisioning or managing servers.

### Can you write a Lambda file?
Yes, here's a simple Lambda function in Python:
```python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello, World!'
    }
```

### What did you achieve with Lambda?
With Lambda, we achieved:
- Serverless architecture
- Reduced operational overhead
- Cost savings by paying only for compute time
- Scalability and high availability

### Limitations of Lambda.
Lambda limitations include:
- Execution time limit of 15 minutes
- Memory allocation limits
- Temporary storage limits
- Concurrency limits

### How Lambda works with containers.
Lambda can run container images, allowing you to package your code and dependencies in a container and deploy it to Lambda.

## ⚖️ Load Balancers

### Difference between ALB and NLB.
- ALB (Application Load Balancer) is best for HTTP/HTTPS traffic
- NLB (Network Load Balancer) is best for TCP/UDP traffic

### Types of AWS Load Balancers.
AWS offers three types of load balancers:
- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Classic Load Balancer (CLB)

### How does weighted routing work in Load Balancers?
Weighted routing allows you to distribute traffic to different targets based on assigned weights. This is useful for testing new application versions or gradually shifting traffic.

### Application is down, throwing 503 – troubleshooting steps.
Troubleshooting steps for a 503 error:
1. Check if the target instances are healthy
2. Verify the load balancer configuration
3. Check the application logs
4. Ensure the security groups allow traffic
5. Verify the target group settings

### Design HA backend using AWS services.
For a highly available backend, use:
- Multiple AZs
- Auto-scaling groups
- Load balancers
- RDS with Multi-AZ deployment
- ElastiCache for caching

### GSLB Load Balancer – how does it work?
Global Server Load Balancing (GSLB) distributes traffic across multiple regions or data centers. It uses DNS to route traffic to the closest or most available server.

## 🌐 Route 53

### Use of Route 53.
Route 53 is a scalable DNS web service that provides domain registration, DNS routing, and health checking.

### Can't configure Route 53 – why?
Common reasons for not being able to configure Route 53 include:
- Insufficient IAM permissions
- Incorrect DNS settings
- Domain not registered with Route 53

### How to configure third-party domains (e.g., GoDaddy) with Route 53?
To configure a third-party domain with Route 53:
1. Create a hosted zone in Route 53
2. Update the domain's nameservers at the registrar to point to Route 53 nameservers

### How does DNS resolution work in Route 53?
Route 53 resolves DNS queries by routing traffic to the appropriate resources based on the routing policy configured for the domain.

## 🐳 ECS / EKS / Fargate

### What is ECS, EKS, and Fargate?
- ECS (Elastic Container Service) is a container orchestration service
- EKS (Elastic Kubernetes Service) is a managed Kubernetes service
- Fargate is a serverless compute engine for containers

### Differences between ECS vs EKS vs Fargate?
- ECS is AWS's own container orchestration service
- EKS is a managed Kubernetes service
- Fargate is a serverless option for running containers without managing servers

### How did you set up ECS using EC2?
To set up ECS using EC2:
1. Create an ECS cluster
2. Launch EC2 instances into the cluster
3. Define task definitions and services
4. Deploy applications using ECS

### What are node groups in AWS EKS?
Node groups in EKS are managed groups of EC2 instances that run Kubernetes nodes. They simplify the management of nodes in an EKS cluster.

### How do you configure EKS node groups?
To configure EKS node groups:
1. Create a node group in the EKS console or using AWS CLI
2. Specify the instance type, AMI, and other configurations
3. Set up auto-scaling policies

### How to upgrade EKS cluster?
To upgrade an EKS cluster:
1. Update the Kubernetes version in the EKS console or using AWS CLI
2. Update the node groups to match the new Kubernetes version
3. Test the cluster after the upgrade

### Cluster auto-scaling – how do you configure it?
To configure cluster auto-scaling in EKS:
1. Install the Cluster Autoscaler
2. Configure auto-scaling policies for node groups
3. Set up CloudWatch alarms for scaling events

### Purpose of using CNI in Kubernetes.
The Container Network Interface (CNI) in Kubernetes is used to configure networking for pods. It allows for flexible and efficient network management.

### Did you run workloads on Fargate?
Yes, we ran workloads on Fargate to eliminate the need to manage servers and simplify container deployment.

## 📉 CloudWatch & Monitoring

### What is CloudWatch used for?
CloudWatch is used for monitoring AWS resources and applications. It collects metrics, logs, and events, and can trigger alarms and automated actions.

### How do you collect CPU metrics in EC2 and send alarms?
To collect CPU metrics in EC2 and send alarms:
1. Enable detailed monitoring for EC2 instances
2. Create CloudWatch alarms based on CPU utilization
3. Configure actions for alarms (e.g., sending notifications)

### How to filter a particular IP from AWS CloudWatch Logs?
You can filter CloudWatch Logs using metric filters or by writing custom queries using CloudWatch Logs Insights.

### What kind of monitoring did you set up for CPU/Disk in AWS?
We set up monitoring for CPU and disk usage using CloudWatch metrics and alarms. This included:
- CPU utilization
- Disk read/write operations
- Disk space usage

### How do you receive alerts in your project?
We receive alerts through:
- SNS notifications
- Email
- Slack integration
- PagerDuty

## 📁 Storage & Backup

### How do you take backup of AWS services?
We take backups of AWS services using:
- AWS Backup for centralized backup management
- Manual snapshots for EBS volumes
- S3 lifecycle policies for data archiving

### Where do you store logs after backup is created?
Logs are stored in S3 buckets with appropriate lifecycle policies to manage retention and costs.

## 🛠️ Terraform with AWS

### Write Terraform code to create EC2, S3, VPC.
Here's a basic example:
```hcl
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "example-subnet"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id
  tags = {
    Name = "example-instance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  tags = {
    Name = "example-bucket"
  }
}
```

### How do you manage Terraform state in AWS (local vs remote)?
We manage Terraform state remotely using S3 and DynamoDB for state locking. This ensures state consistency and allows for team collaboration.

### What happens if Terraform state file is lost?
If the Terraform state file is lost, you may lose track of the resources managed by Terraform. It's crucial to use remote state storage and backups to prevent this.

### How do you migrate backend to S3 with DynamoDB locking?
To migrate the Terraform backend to S3 with DynamoDB locking:
1. Create an S3 bucket and DynamoDB table
2. Configure the backend in your Terraform configuration
3. Initialize Terraform with the new backend

### What is backend.tf – not visible in storage account?
The `backend.tf` file is used to configure the Terraform backend. If it's not visible in the storage account, ensure that the file is correctly named and located in your Terraform project directory. 