# Step-by-Step Guide: Deploy a Node.js App to EKS with Fargate and ALB

This guide walks you through setting up an AWS EKS cluster with Fargate profiles, installing the AWS Load Balancer Controller, deploying a Node.js app, and accessing it publicly via ALB.

---

## Table of Contents

- [1. Install CLI Tools](#1-install-cli-tools)
- [2. Configure AWS CLI](#2-configure-aws-cli)
- [3. Create EKS Cluster with Fargate](#3-create-eks-cluster-with-fargate)
- [4. Create Fargate Profile](#4-create-fargate-profile)
- [5. Connect kubectl to EKS](#5-connect-kubectl-to-eks)
- [6. Install AWS Load Balancer Controller](#6-install-aws-load-balancer-controller)
- [7. Create Kubernetes Resources for Node.js App](#7-create-kubernetes-resources-for-nodejs-app)
- [8. Apply Kubernetes Manifests](#8-apply-kubernetes-manifests)
- [9. Access Node.js App via ALB](#9-access-nodejs-app-via-alb)

---

## 1. Install CLI Tools

### 1.1 Install AWS CLI
```bash
brew install awscli
```
A command-line tool to manage AWS services like EC2, S3, IAM, EKS, CloudFormation, etc.

### 1.2 Install kubectl
```bash
brew install kubectl
```
kubectl is the command-line tool to interact with Kubernetes clusters.

### 1.3 Install eksctl
```bash
brew install eksctl
```
eksctl is a command-line tool that makes it easy to create, manage, and delete AWS EKS (Elastic Kubernetes Service) clusters.
---

## 2. Configure AWS CLI
```bash
aws configure
```
Provide:
- AWS Access Key
- AWS Secret Key
- Region (example: `us-east-1`)

✅ Now your CLI is connected to AWS.

---

## 3. Create EKS Cluster with Fargate
```bash
eksctl create cluster --name nodejs-cluster --region us-east-1 --fargate
```
Creates EKS cluster, VPC, subnets, route tables, IAM roles, and a default Fargate profile.

---

## 4. Create Fargate Profile
```bash
eksctl create fargateprofile --cluster nodejs-cluster --name nodejs-profile --namespace nodejs
```
✅ Pods in `nodejs` namespace will automatically run on Fargate.

---

## 5. Connect kubectl to EKS
```bash
aws eks update-kubeconfig --region us-east-1 --name nodejs-cluster
```
✅ This configures kubectl to connect to your cluster.

---

## 6. Install AWS Load Balancer Controller

### 6.1 Create OIDC Provider
```bash
eksctl utils associate-iam-oidc-provider --cluster nodejs-cluster --approve
```

### 6.2 Create IAM Policy
```bash
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```
First command links your EKS cluster to an AWS IAM OIDC provider, allowing secure pod-level access to AWS services via IAM roles.
 You need this if you want to give AWS permissions (like S3, DynamoDB, SQS access) to pods running inside your EKS cluster.

Then Create IAM Policy:

 When you install the AWS Load Balancer Controller (for ALB/ELB Ingress):
    It needs AWS permissions to create and manage:
            Elastic Load Balancers (ALB/NLB)
            Target groups
            Listener rules
            Security groups
    
    Kubernetes pods cannot directly have AWS permissions.
    Instead, the pod assumes an IAM Role (using IRSA and OIDC) — this IAM Role must have this policy attached.

        ✅ That's why you create this custom IAM Policy.

### 6.3 Create Service Account
```bash
eksctl create iamserviceaccount \
  --cluster nodejs-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<your-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```
Here creating a service account, and attaching IAM role 
    So when the Load Balancer Controller pod runs using this service account, it automatically gets AWS permissions without needing access keys!
    This command sets up the link between a Kubernetes service account and an IAM role, so the Load Balancer Controller pods can securely access AWS APIs.

### 6.4 Install Controller using Helm
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=nodejs-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=<your-vpc-id>
```

✅ Load Balancer Controller is now running!

---

## 7. Create Kubernetes Resources for Node.js App

- `deployment.yaml`: Pulls Node.js image from ECR.
- `service.yaml`: Exposes app inside the cluster.
- `ingress.yaml`: Creates ALB and routes external traffic.

---

## 8. Apply Kubernetes Manifests
```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
```

✅ Kubernetes will:
- Deploy Node.js app to Fargate
- Create an ALB
- Expose the app publicly

---

## 9. Access Node.js App via ALB
```bash
kubectl get ingress nodejs-ingress -n nodejs
```

Example output:
```plaintext
NAME             CLASS    HOSTS   ADDRESS                                                                PORTS   AGE
nodejs-ingress   <none>   *       k8s-nodejs-nodejsin-316c12bb94-2125159329.us-east-1.elb.amazonaws.com   80      30m
```

✅ Open the `ADDRESS` (ALB DNS name) in your browser.
✅ Your Node.js app is now LIVE! 🎉

---

# 🎯 Congratulations!

✅ You have successfully:
- Set up an EKS cluster with Fargate
- Installed AWS Load Balancer Controller
- Deployed your Node.js app
- Made it publicly accessible via ALB 🚀

---

# 📋 Final Tips
- Ensure your app responds with HTTP 200 OK on `/` path for ALB health checks.
- Use namespaces wisely for Fargate profiles.
- Monitor ALB Target Group health in AWS Console.

Happy Kubernetes-ing
