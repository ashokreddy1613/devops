# Step by step guide to create EKS cluster with Fargate 

## Step 1: Install CLI Tools (install depends on your OS)
 
 Install awscli

   A command-line tool to manage AWS services like EC2, S3, IAM, EKS, CloudFormation, etc.

``` bash brew install awscli
```
 Install kubectl

  kubectl is the command-line tool to interact with Kubernetes clusters.

  ``` brew install kubectl
```
 Install eksctl

    eksctl is a command-line tool that makes it easy to create, manage, and delete AWS EKS (Elastic Kubernetes Service) clusters.

 ``` brew install eksctl
```
## Step2: Configure AWS CLI

  Run this and enter your credentials:

  ```
  aws configure
```

  You’ll need:

    AWS Access Key

    AWS Secret Key

    Region (example: us-east-1)

✅ Now your CLI is connected to AWS.


## Step 3: Create EKS Cluster with Fargate
  
  Now use eksctl to create cluster with Fargate profile

 ``` eksctl create cluster --name nodejs-cluster --region us-east-1 --fargate
```
   This will create EKS cluster, VPC, Subnets, Route tables automatically, a default Fargate Profile and setup IAM roles

## Step 4: Create Fargate Profile 

```
eksctl create fargateprofile --cluster nodejs-cluster --name nodejs-profile --namespace nodejs
```
 Any pods in nodejs namespace will automatically run on Fargate (serverless).

## Step 5: Connect your kubectl to EKS

 (Usually happens automatically if you used eksctl create cluster, but you can manually update kubeconfig):

 ```
aws eks update-kubeconfig --region us-east-1 --name nodejs-cluster
```
  This command prepares your local kubectl to talk to your AWS EKS cluster easily.


## 2. Install AWS Load Balancer Controller (ALB Controller)

### 2.1 Add IAM Policy for ALB Controller

 First create IAM OIDC provider:
 ```
  eksctl utils associate-iam-oidc-provider --cluster your-cluster-name --approve
```

 This command links your EKS cluster to an AWS IAM OIDC provider, allowing secure pod-level access to AWS services via IAM roles.
 You need this if you want to give AWS permissions (like S3, DynamoDB, SQS access) to pods running inside your EKS cluster.

  Then create IAM Policy 
  
  ``` curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```
    When you install the AWS Load Balancer Controller (for ALB/ELB Ingress):
    It needs AWS permissions to create and manage:
            Elastic Load Balancers (ALB/NLB)
            Target groups
            Listener rules
            Security groups
    
        Kubernetes pods cannot directly have AWS permissions.
        Instead, the pod assumes an IAM Role (using IRSA and OIDC) — this IAM Role must have this policy attached.

        ✅ That's why you create this custom IAM Policy.

### 2.2 Create ServiceAccount for ALB Controller

  ```
  eksctl create iamserviceaccount \
  --cluster <your-cluster-name >\
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<your-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```
    Here creating a service account, and attaching IAM role 
    So when the Load Balancer Controller pod runs using this service account, it automatically gets AWS permissions without needing access keys!
    This command sets up the link between a Kubernetes service account and an IAM role, so the Load Balancer Controller pods can securely access AWS APIs.

### 2.3 Install ALB Controller using Helm

``` 
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=<vpc-xxxxxxxx>
```

     Now ALB Controller is running inside your cluster

 

## 3 Create Kubernetes Resources for Node App
   
   Now let’s create Deployment, Service, and Ingress

    Deployement.yaml-> This pulls image directly from ECR
    Service.yaml->  This exposes your app internally to the cluster.
    Ingress.yanl ->  This tells AWS Load Balancer Controller:
                    Create ALB
                    Route external traffic to your app

## 4 Apply Kubernetes files

    ```
      kubectl apply -f k8s/deployment.yaml
      kubectl apply -f k8s/service.yaml
      kubectl apply -f k8s/ingress.yaml
```
   After run the above commands:

    Kubernets will Pull your Node.js app from ECR, deploy it on Fargate pods (serverless!)
    Create a Load Balancer (ALB) and Expose your app publicly

## 5. Get ALB DNS URL 
```
     kubectl get ingress nodejs-ingress
```
  you will get something like this:

    ```
    NAME             CLASS    HOSTS   ADDRESS                                                                 PORTS   AGE
    nodejs-ingress   <none>   *       k8s-nodejs-nodejsin-316c12bb94-2125159329.us-east-1.elb.amazonaws.com   80      30m
```
   Copy the address and open your browser, Your Node app is LIVE

  
