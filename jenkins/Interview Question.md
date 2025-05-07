
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

# Jenkins CI/CD Interview Questions and Best Practice Answers

## 1. How would you create a Jenkins pipeline to build, test, and deploy a Java application?

Use a declarative Jenkinsfile stored in the root of your Git repo:

```groovy
pipeline {
  agent any
  tools { maven 'maven3' }
  stages {
    stage('Build') {
      steps { sh 'mvn clean compile' }
    }
    stage('Test') {
      steps { sh 'mvn test' }
    }
    stage('Package') {
      steps { sh 'mvn package' }
    }
    stage('Deploy') {
      steps { sh './deploy.sh' }
    }
  }
}
```

## 2. Describe how you would implement a Jenkins pipeline using a Jenkinsfile stored in the source code repository.
- Create a new Pipeline job.
- Select "Pipeline script from SCM".
- Choose Git and provide the repository URL.
- Specify the branch and path to Jenkinsfile (usually root).
- Jenkins automatically executes the pipeline from that file.

## 3. How would you set up a Multibranch Pipeline to automatically create jobs for each branch in a Git repository?
- Create a new Multibranch Pipeline job.
- Configure the Git repo under "Branch Sources".
- Add credentials if required.
- Jenkins scans all branches containing a Jenkinsfile and creates jobs per branch.

## 4. How can you configure a Jenkins pipeline to run multiple stages in parallel?

```groovy
stage('Tests') {
  parallel {
    stage('Unit Tests') { steps { sh 'mvn test' } }
    stage('Integration Tests') { steps { sh 'mvn verify -P integration' } }
  }
}
```

## 5. How would you configure a Jenkins job to trigger a build based on changes in a Git repository?
- Enable "GitHub hook trigger for GITScm polling" in job config.
- Set up a webhook in GitHub to notify Jenkins on changes.
- Or use "Poll SCM" with cron syntax (e.g., `H/5 * * * *`).

## 6. Describe how you would set up a Jenkins job that accepts parameters from the user before running the build.

```groovy
parameters {
  string(name: 'ENV', defaultValue: 'dev', description: 'Target environment')
}
```

Usage: `sh "./deploy.sh ${params.ENV}"`

## 7. How would you configure Jenkins to send an email notification upon build completion, only if the build fails?

```groovy
post {
  failure {
    mail to: 'devops@company.com',
         subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
         body: "Check details: ${env.BUILD_URL}"
  }
}
```

## 8. How can you archive and publish build artifacts in Jenkins for later use or download?

```groovy
archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
```

## 9. How do you securely manage and use credentials (such as API keys or SSH keys) within Jenkins jobs?

```groovy
withCredentials([string(credentialsId: 'api-key-id', variable: 'API_KEY')]) {
  sh 'curl -H "Authorization: Bearer $API_KEY" ...'
}
```

## 10. How would you pass and use environment variables within a Jenkins pipeline?

```groovy
environment {
  DEPLOY_ENV = 'prod'
}
steps {
  sh 'echo Deploying to $DEPLOY_ENV'
}
```

## 11. Describe how you would configure Jenkins to use multiple build agents for distributed builds.
- Add and configure Jenkins agents.
- Assign labels to agents.
- Use `agent { label 'docker' }` for specific steps or stages.

## 12. How can you ensure that a particular job runs on a specific Jenkins agent or a group of agents?

```groovy
pipeline {
  agent { label 'linux' }
}
```

## 13. How would you configure Jenkins to build and deploy Docker images?

```groovy
stage('Build Docker Image') {
  steps {
    script {
      def app = docker.build("myapp:${BUILD_NUMBER}")
      docker.withRegistry('', 'dockerhub-cred') {
        app.push()
      }
    }
  }
}
```

## 14. A pipeline stage intermittently fails due to network issues. How would you add retry logic to handle such failures?

```groovy
retry(3) {
  sh 'curl -f http://unstable-service || exit 1'
}
```

## 15. How would you identify and install necessary plugins for Jenkins to support a specific build tool or technology?
- Navigate to "Manage Jenkins" → "Plugin Manager".
- Search and install relevant plugins (e.g., Maven Integration Plugin).

## 16. Describe how you would use Shared Libraries to reuse code across multiple Jenkins pipelines.
- Create a Git repo with `/vars` and `/src` directories.
- Register the library under "Global Shared Libraries".
- Use in Jenkinsfile:

```groovy
@Library('shared-lib') _
myReusableStep()
```

## 17. How can you manage user permissions and secure your Jenkins instance?
- Enable "Matrix-based security" under global settings.
- Configure roles via "Role-based Authorization Strategy Plugin".
- Restrict anonymous access.

## 18. What strategy would you use to back up Jenkins configurations and jobs, and how would you restore them?
- Backup `$JENKINS_HOME` directory regularly.
- Include `jobs/`, `config.xml`, `credentials.xml`.
- Restore by copying files to a fresh Jenkins install.

## 19. How would you visualize and monitor the progress of your Jenkins pipelines?
- Use **Blue Ocean Plugin** or **Pipeline Stage View**.
- Monitor logs and artifacts under each build run.

## 20. How can you integrate test reports (e.g., JUnit, NUnit) into Jenkins to display test results?

```groovy
junit 'target/surefire-reports/*.xml'
```

## 21. How do you configure Jenkins to automatically discover and run pipelines defined in source control?
- Use **Multibranch Pipeline** or **GitHub Organization** job type.
- Jenkins auto-detects branches and Jenkinsfile definitions.

## 22. What steps would you take to manage long-running jobs that might time out or exceed resource limits?

```groovy
timeout(time: 30, unit: 'MINUTES') {
  sh './heavy-task.sh'
}
```

- Monitor CPU/memory via agent-level tools.

## 23. How would you set up a build promotion strategy in Jenkins to promote builds through different stages (e.g., Dev, QA, Prod)?
- Use build parameters to select environments.
- Tag or mark a build after successful QA.
- Optionally use **Promoted Builds Plugin**.

## 24. Describe how you would set up Jenkins to trigger builds based on GitHub pull requests.
- Install **GitHub Branch Source Plugin**.
- Configure webhook in GitHub.
- Jenkins creates PR-specific jobs (Change Request builds).

## 25. How would you troubleshoot and debug a failing Jenkins pipeline?
- Check **Console Output** logs.
- Use `echo`, `printenv`, or `set -x` in shell steps.
- Re-run with verbose build flags: `mvn -X`, `npm --verbose`.

## 26. How can you use Job DSL to automate the creation and configuration of Jenkins jobs?

```groovy
job('my-java-app') {
  scm {
    git('https://github.com/org/repo.git')
  }
  triggers {
    scm('H/5 * * * *')
  }
  steps {
    maven('clean install')
  }
}
```

## 27. How would you configure a matrix build in Jenkins to test an application across multiple environments or configurations?

```groovy
matrix {
  axes {
    axis {
      name 'OS'
      values 'ubuntu', 'windows'
    }
  }
  stages {
    stage('Test') {
      steps {
        sh 'run-tests.sh'
      }
    }
  }
}
```

## 28. What measures would you take to secure sensitive information within your Jenkins pipeline scripts?
- Use **Jenkins Credentials Manager**.
- Avoid echoing or printing secrets.
- Use `withCredentials {}` blocks.
- Mask sensitive outputs using `echo "***"` or `set +x`.
