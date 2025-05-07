Kubernetes-Specific Interview Questions (Grouped by Topic)
🔹 Core Architecture & Concepts
Kubernetes architecture

Explain Kubernetes architecture

Architecture of Kubernetes

What is pod in Kubernetes?

What is the use of etcd in Kubernetes?

What is kubelet?

What is kube-proxy?

What is ingress in Kubernetes?

What is ingress controller?

What is service vs deployment?

What are deployments, daemonsets, statefulsets?

Purpose of scheduler in k8s

CoreDNS in k8s

Purpose of using CNI in K8s

🔹 Deployments & StatefulSets
Deployment vs stateful set

Difference between deployment and statefulset

What is the difference between deployment and stateful set

Explain terms in deployment.yml file in Kubernetes

Can we run 1 container with 2 pods?

Design the deployment of the pod with replica set set as 3 and having apache httpd image

What is rolling update?

What is the deployment strategy you are using?

If we have pods in both deployment and statefulset, how will rolling update work?

Suppose mongo-0 pod dies, what will be new pod name?

🔹 Services, Networking & Ingress
Types of Service in Kubernetes

Use case of NodePort and Cluster IP service type

Difference between ClusterIP, NodePort, and LoadBalancer

How to restrict the communication between pods? → NetworkPolicy

What component should be added in NetworkPolicy YAML file?

If 2 pods are in different namespace, how to make them communicate securely?

What happens if Ingress is not routing traffic?

What is the difference between service and deployment?

How is traffic routed inside Kubernetes clusters?

🔹 State, Storage, Volumes
Difference between PV and PVC in Kubernetes

What is Persistent Volume (PV) and Persistent Volume Claim (PVC)?

What is the purpose of using StorageClass in Kubernetes?

Storage classes in Kubernetes

What is PDB (Pod Disruption Budget) in Kubernetes?

🔹 Cluster Management & Upgrades
How to upgrade EKS cluster

What are the steps to upgrade EKS cluster?

Explain the upgrade process for Kubernetes cluster with zero downtime

What key things should be verified post-upgrade?

🔹 Monitoring & Observability
How do you monitor the cluster through Prometheus?

Explain installation of Prometheus and Grafana

How do you secure your AKS cluster?

How do you make your AKS cluster highly available?

How is Prometheus setup?

🔹 Security & Access Control
What is RBAC?

Diff between Role and RoleBinding

What roles are provided for junior team member in k8s?

How do you secure public API for on-prem setup?

How do you use secrets in Kubernetes?

What encryption methods are used for secrets?

How to use Azure Key Vault’s secrets in AKS?

How do you fetch rotated secrets from Azure Vault inside pods?

🔹 Scheduling, Taints & Affinity
What is taint/toleration?

Difference between nodeSelector, node affinity vs taint, toleration

If I want to deploy my app on worker node2, what should I do?

When pods fail to drain, what do you do?

If I want pod to run on large/medium nodes only, how can I configure?

🔹 Scaling & Auto Scaling
How does Kubernetes handle scaling?

What is HPA? What are all types of triggers used?

Difference between scaling and autoscaling

What is cluster autoscaler and horizontal pod autoscaler?

How to configure cluster auto-scaling?

🔹 Debugging & Troubleshooting
How to troubleshoot ImagePullBackOff error?

If pod is in pending state, how do you troubleshoot?

If pod is constantly restarting, what steps to follow?

What happens if pod exceeds memory limit?

What happens if pod.yaml failed?

Pod fails to schedule: 0/5 nodes are available: insufficient memory → How to debug?

If a pod crashes and you can't enter it, how do you troubleshoot?

🔹 Commands & Usage
Basic Kubernetes commands

What commands used in Kubernetes?

What is the command to add annotation/labels to existing pod?

Write deployment file for Kubernetes

Write deployment.yaml

What is inside deployment.yaml or Helm chart?

What is the output of Helm chart?

🔹 Miscellaneous Kubernetes Topics
What are namespaces in Kubernetes?

Difference between stateless and stateful application

How do you manage data of stateless applications?

How many containers can run in a pod?

What is the use case of multi-container pod?

Can we deploy services on master node?

Limiting the resource usage not through deployment.yaml but via namespace

What is the purpose of using init containers?

What happens if etcd stops working?

What is the behavior of restartPolicy: Never?

Custom Resource in Kubernetes

How do you use Custom Resources in Kubernetes?

Design Istio setup for your Kubernetes cluster

What is the purpose of kube-proxy?

What is calico?

How to take backup of Kubernetes cluster?

What are the layers in Kubernetes architecture?

Can you write extensions in Grafana?

If control plane goes down what happens to worker nodes?
