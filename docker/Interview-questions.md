# Docker Interview Questions

## 🔧 Basics and Concepts

1. **What is Docker and how do you use it in your project?**
   - Docker is a platform for developing, shipping, and running applications in isolated environments called containers. In my project, I use Docker to ensure consistency across development, testing, and production environments, making it easier to manage dependencies and deploy applications.

2. **What is the difference between Docker image and container?**
   - A Docker image is a lightweight, standalone, executable package that includes everything needed to run a piece of software, including the code, runtime, libraries, and dependencies. A container is a running instance of an image, isolated from the host system and other containers.

3. **What is Docker architecture?**
   - Docker architecture consists of three main components: the Docker client, the Docker daemon, and the Docker registry. The client communicates with the daemon, which manages Docker objects like images, containers, networks, and volumes. The registry stores Docker images.

4. **Why use Kubernetes instead of Docker Swarm?**
   - Kubernetes offers more advanced features for orchestration, scaling, and management of containerized applications compared to Docker Swarm. It provides better support for complex deployments, self-healing, and integration with cloud-native tools.

5. **How is Docker operable on a Linux machine?**
   - Docker runs natively on Linux using the host's kernel. It leverages Linux features like cgroups and namespaces to provide isolation and resource management for containers.

6. **What happens if the Docker image has port 8080 and the container/application has a different port?**
   - If the container exposes a different port than the image, you need to map the container's port to the host's port using the `-p` flag when running the container. For example, `docker run -p 8080:3000` maps the container's port 3000 to the host's port 8080.

7. **Did you build the Dockerfile using CodeBuild?**
   - Yes, I used AWS CodeBuild to automate the building of Docker images from Dockerfiles, ensuring consistent and reproducible builds in my CI/CD pipeline.

8. **Are you using Dockerfile?**
   - Yes, I use Dockerfiles to define the environment and dependencies for my applications, ensuring they run consistently across different environments.

## 📄 Dockerfile-Specific

1. **What is inside a Dockerfile?**
   - A Dockerfile contains instructions to build a Docker image, including the base image, dependencies, environment variables, and commands to run the application.

2. **Write a sample Dockerfile.**
   ```dockerfile
   FROM node:14
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   EXPOSE 3000
   CMD ["npm", "start"]
   ```

3. **What is a multistage Dockerfile?**
   - A multistage Dockerfile uses multiple stages to build an image, allowing you to separate the build environment from the runtime environment. This reduces the final image size by excluding build tools and dependencies.

4. **How to reduce the size of Dockerfile?**
   - Use a smaller base image, combine RUN commands, remove unnecessary files, and use multistage builds to separate build and runtime environments.

5. **What is the difference between CMD and ENTRYPOINT?**
   - `CMD` provides default commands for the container, which can be overridden at runtime. `ENTRYPOINT` defines the executable that will always run when the container starts, and `CMD` arguments are passed to it.

6. **Difference between COPY and ADD in Dockerfile.**
   - `COPY` is used to copy files from the host to the container, while `ADD` can also extract tar files and download files from URLs. `COPY` is preferred for simplicity and clarity.

## 🔌 Networking and Storage

1. **What is Docker networking?**
   - Docker networking allows containers to communicate with each other and the outside world. It provides different network drivers like bridge, host, overlay, and none.

2. **Types of networking in Docker and explain in detail.**
   - Docker supports several network types:
     - **Bridge:** Default network for containers on the same host.
     - **Host:** Uses the host's network directly.
     - **Overlay:** Connects containers across multiple Docker hosts.
     - **None:** Isolates containers from networking.

3. **Which Docker network is used to isolate communication between two containers?**
   - The `none` network driver is used to isolate containers from networking, preventing them from communicating with other containers or the host.

4. **Does Docker have its own kernel?**
   - No, Docker uses the host's kernel. It leverages Linux features like cgroups and namespaces to provide isolation.

5. **Difference between S3 and EBS (related to Docker volume use case implied).**
   - S3 is a scalable object storage service, while EBS is a block storage service for EC2 instances. For Docker volumes, EBS is used for persistent storage attached to instances, while S3 is used for storing Docker images and backups.

6. **Why is Kubernetes needed if Docker volumes exist?**
   - Kubernetes provides orchestration, scaling, and management of containers, while Docker volumes handle persistent storage. Kubernetes is needed for managing containerized applications across clusters, ensuring high availability and scalability.

## 📦 Container Use and Optimization

1. **If Docker containers are consuming too much disk space, how do you fix it?**
   - Use `docker system prune` to remove unused images, containers, and volumes. Optimize Dockerfiles to reduce image size, and use multistage builds.

2. **How do you fix security issues in Docker images?**
   - Regularly update base images, scan images for vulnerabilities using tools like Trivy or Clair, and follow best practices like running containers as non-root users.

3. **How do you build and push a Docker image to ACR?**
   - Use the following commands:
     ```bash
     docker build -t myregistry.azurecr.io/myimage:tag .
     docker push myregistry.azurecr.io/myimage:tag
     ```

4. **What security measures/tools were taken in your CI/CD pipeline related to Docker?**
   - I implemented image scanning, used secrets management, and enforced least privilege principles in my CI/CD pipeline to secure Docker images and containers.

5. **Write a multistage Dockerfile for a Node.js app — removing secrets and unnecessary layers.**
   ```dockerfile
   FROM node:14 AS builder
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   RUN npm run build

   FROM node:14-slim
   WORKDIR /app
   COPY --from=builder /app/dist ./dist
   COPY package*.json ./
   RUN npm install --production
   EXPOSE 3000
   CMD ["npm", "start"]
   ```

## 🔁 Deployment and Runtime

1. **How do you deploy a Docker-based app to Kubernetes?**
   - Define a Kubernetes deployment YAML file, specifying the Docker image, replicas, and resources. Use `kubectl apply -f deployment.yaml` to deploy the application.

2. **In your projects, how many containers did you run? Can you give a use case where 4–5 containers are in a Pod?**
   - In a microservices architecture, a single Pod might run multiple containers for a single application. For example, a web application Pod could include containers for the main app, a sidecar for logging, a proxy, a cache, and a monitoring agent. 