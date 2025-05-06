
# DevOps CI/CD Process with Jenkins, Docker, and ArgoCD

## 1. CI/CD Workflow

We use the following tools orchestrated via **Jenkins** to implement a complete CI/CD pipeline:

- **Maven** for Java builds
- **SonarQube** for code quality analysis
- **AppScan/Trivy** for security scanning
- **Docker** for containerization
- **ArgoCD** for GitOps-based CD
- **Kubernetes** as the deployment platform
- **GitHub** as the version control system

### CI Stages

1. **Checkout**: Pull the latest code committed by the developer.
2. **Build**: Compile the code and run unit tests using Maven and a Java testing framework.
3. **Code Scan**: Analyze code using SonarQube for security vulnerabilities and code quality issues.
4. **Security Scan**: Use AppScan or Trivy to scan for vulnerabilities in dependencies or container layers.
5. **Docker Image Build**: Build the container image for the application.
6. **Image Scan**: Scan the Docker image for vulnerabilities.
7. **Push to Registry**: Push the built image to a container registry (e.g., Docker Hub or AWS ECR).

### CD Workflow (GitOps)

- We use **ArgoCD** for Continuous Deployment.
- Once the image is pushed to the registry, **ArgoCD Image Updater** monitors the registry.
- On detecting a new tag, it patches the Kubernetes manifest in the Git repository.
- ArgoCD detects the change in Git and automatically deploys the application to the Kubernetes cluster.

## 2. Jenkins Pipeline Triggers

Jenkins pipelines can be triggered in several ways:

- **Poll SCM**: Jenkins periodically checks Git for changes.
- **GitHub Webhook**: GitHub sends a push event to Jenkins to trigger a build.
- **Manual Trigger**: Users can manually start a pipeline from the Jenkins UI.
- **API Trigger**: Use a REST API call to start the pipeline.

## 3. Jenkins Backup Strategy

To backup Jenkins:

- **Configuration**: Backup the `~/.jenkins` or `$JENKINS_HOME` directory.
- **Plugins**: Backup the `plugins/` folder inside `$JENKINS_HOME`.
- **Jobs**: Backup the `jobs/` folder for job definitions.
- **User Content**: Archive custom files, scripts, and artifacts.
- **Database** (if used): Use `mysqldump` or a similar tool to backup external databases.

## 4. Secret Management in Jenkins

Secure handling of secrets:

- **Credentials Plugin**: Securely store and inject credentials using `withCredentials` in pipelines.
- **Environment Variables**: Less secure; not recommended for secrets.
- **HashiCorp Vault**: Integration available for advanced secret management.
- **Cloud Secret Managers**: Use AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager.

## 5. Shared Modules in Jenkins

Shared modules help reuse code and configuration across Jenkins jobs:

- **Shared Libraries**: Centralized Groovy scripts and reusable pipeline logic.
- **Global Variables**: Shared variables across stages or pipelines.
- **Common Jenkinsfile**: Use a common Jenkinsfile for multiple jobs.
- **Reusable Scripts**: Store bash, Python, or Groovy scripts in Git and import them.

## 6. Jenkins Pipelines: Declarative vs Scripted

| Type          | Description                                           |
|---------------|-------------------------------------------------------|
| Declarative   | Simplified, structured syntax (`pipeline {}` block)  |
| Scripted      | Full flexibility using Groovy (`node {}` block)      |

## 7. GitHub Integration with Jenkins

To auto-trigger builds:

1. Install **GitHub Integration Plugin** in Jenkins.
2. Create a webhook in your GitHub repo:
   - URL: `http://<jenkins-url>/github-webhook/`
3. Enable **"GitHub hook trigger for GITScm polling"** in Jenkins job configuration.

## 8. Jenkins Pipeline for Dockerized App

Steps to deploy a Dockerized Java app:

1. Write a `Jenkinsfile` with stages: **build → test → scan → image build → push → deploy**
2. Use `docker` CLI or Docker Pipeline plugin to build/push images.
3. Use Kubernetes manifests in Git (for GitOps), or deploy directly using `kubectl`.

## 9. Maven Fundamentals

### Purpose of `pom.xml`

`pom.xml` is the configuration file for Maven. Key sections include:

- `<dependencies>`: Project dependencies
- `<build>`: Plugins and configurations
- `<repositories>`: Additional repo sources

### Maven Lifecycle Goals

- `compile`: Compiles Java code.
- `test`: Executes unit tests.
- `package`: Builds JAR/WAR artifact.

### Adding Dependencies

Use the `<dependencies>` section in `pom.xml`:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
  <version>2.6.0</version>
</dependency>
```

## 10. Jenkins Pipeline Scenarios

### ✅ Restart a Failed Build at Specific Stage
Use checkpointing or:

```groovy
options {
  skipStagesAfterUnstable()
}
```

### ✅ Handling Timeouts
```groovy
timeout(time: 10, unit: 'MINUTES') {
  // long-running stage
}
```

### ✅ Using Credentials Securely
```groovy
withCredentials([usernamePassword(credentialsId: 'my-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
  sh "curl -u $USER:$PASS https://secure.api"
}
```
## 📘 Jenkins Advanced Concepts

### 🔹 1. Jenkins Pipeline Syntax: Declarative vs Scripted

| Type          | Description |
|---------------|-------------|
| **Declarative Pipeline** | Uses a structured and predefined syntax within a `pipeline {}` block. Easier to read and write. Ideal for simple CI/CD tasks. |
| **Scripted Pipeline**    | Based on Groovy, written inside a `node {}` block. Offers more flexibility and programmatic control, but is harder to maintain. |

**Declarative Example:**
```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building...'
      }
    }
  }
}
```

**Scripted Example:**
```groovy
node {
  stage('Build') {
    echo 'Building...'
  }
}
```

### 🔹 2. Distributed Builds in Jenkins

To scale Jenkins and run jobs on remote nodes:

- Go to **Manage Jenkins → Manage Nodes and Clouds**
- Add a **new node (agent)** with SSH or JNLP launch method
- Define labels for agents and assign them to specific jobs

### 🔹 3. Manual Approval with `input` Step

Use the `input` step to pause the pipeline and wait for user interaction.

**Example:**
```groovy
input message: 'Deploy to production?', ok: 'Deploy'
```

### 🔹 4. Jenkins Security Best Practices

- Enable **Role-Based Access Control (RBAC)**
- Use **HTTPS** for Jenkins UI
- Store secrets in **Credentials Manager**
- Restrict access to sensitive jobs and configurations

### 🔹 5. Blue Ocean in Jenkins

- Blue Ocean is a modern, visual interface for Jenkins pipelines.
- It provides intuitive visualization of stages, steps, logs, and approvals.
- Enables easier pipeline creation and editing.

### 🔹 6. Jenkinsfile Parameters

Parameters allow users to provide input to pipelines at runtime.

**Example:**
```groovy
parameters {
  string(name: 'BRANCH', defaultValue: 'main', description: 'Git branch to build')
}
```

Access in pipeline:
```groovy
echo "Building branch: ${params.BRANCH}"
```

### 🔹 7. Securely Store and Use Credentials

Use `withCredentials` to safely access secrets:

**Example:**
```groovy
withCredentials([usernamePassword(credentialsId: 'cred-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
  sh 'curl -u $USERNAME:$PASSWORD https://secure-api'
}
```

### 🔹 8. Post-Build Actions

Post-build actions execute after the main stages:

- Send notifications (e.g., Slack, email)
- Archive artifacts
- Trigger downstream builds

**Example:**
```groovy
post {
  success {
    echo 'Build succeeded!'
  }
  failure {
    echo 'Build failed!'
  }
}
```

### 🔹 9. Archiving Artifacts

Use `archiveArtifacts` to retain important build outputs.

**Example:**
```groovy
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
```

### 🔹 10. Jenkins Shared Libraries

Shared Libraries allow reuse of common pipeline code across multiple projects.

- Store Groovy scripts in a separate Git repo
- Load using:
```groovy
@Library('my-shared-lib') _
```
- Define reusable `vars/*.groovy` and `src/*.groovy` files in the library repo
