# How to Deploy a Containerized Node.js App on a Kubernetes Cluster

## Build and Deploy an autoscaling Node.js and MongoDB API using Docker, and Kubernetes.

### Containerization and orchestration have become vital in modern application development for efficient deployment and management of scalable applications. Leading the pack, Docker and Kubernetes provide a powerful combination, enabling seamless packaging, deployment, and scaling of applications.
### In this tutorial, Specifically, we will focus on building and deploying an autoscaling Todo API built with Node.js, Express.js, and MongoDB. We’ll explore the step-by-step process of setting up a local Kubernetes environment, containerizing the Node.js application using Docker, and configuring a Kubernetes autoscaling deployment for our application


## Prerequisites:
 1. Node.js :  Ensure that you have Node.js installed on your machine.
 2. Docker : Install Docker on your machine to containerize and manage your application.
 3. Kubernetes: make sure to familiarize yourself with the basic components of Kubernetes. 
 4. AWS ECR : AWS image registry that helps to storage the docker image
 5. AWS EKS : Kubernetes cluster where we deploy node application.  
 6. Kubectl : install Kubectl, a command line tool for communicating with a Kubernetes  
    cluster using the Kubernetes API.


First, clone the repository or simple node app ready.


Next, let’s containerize our app using Docker. A Dockerfile is a text file that contains a set of instructions used to build a Docker image. It defines the steps needed to create a self-contained environment for running your application.

## Build and push image to AWS ECR Registry

In order for the Kubernetes cluster to pull the Docker image of our application during deployment, we need to make the image accessible. This can be done in various ways, one way is by pushing the docker image to a ECR registry, which can be a public, private, or local registry.

 To do that, Make sure you have installed:

 1.AWS CLI (v2 recommended)

 2.Docker installed and running

 3.AWS CLI configured with your credentials:


 ```bash aws configure ```

    (Enter your AWS Access Key, Secret Key, Region)

## Create ECR Repository

 ```bash aws ecr create-repository --repository-name test-kuber --region your-region ```

## Authenticate Docker to ECR 
 
 ```bash 
    aws ecr get-login-password --region us-east-1 | docker login --username AWS 
    --password-stdin 123456789012(enter you aws account here).dkr.ecr.us-east-1.amazonaws.com
```

## lets build the image and tag it 
 
  ### Build a Docker image 

  ```bash
docker build -t kubernetes-app .
```

  ### Tag image for ECR

   ``` bash docker tag "image":latest <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/ 
      "ECR Repository":latest 
   ```

## Push to ECR

  ```bash docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/"ECR Repo":latest
```