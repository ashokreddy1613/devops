# CI/CD Interview Answers

## What is the role of continuous integration?

The role of Continuous Integration (CI) is to ensure that code changes made by developers are:

- Automatically tested
- Integrated frequently into a shared codebase
- Validated early to catch errors as soon as possible

That’s being said, doing automated build, test, early bug detection, artifact generation, improve code quality.

## CI/CD pipeline needs rollback capability. How would you implement it?

Rollback is a critical part of a resilient CI/CD pipeline, especially in production. A good rollback strategy ensures you can revert to a previously working version quickly and safely in case of failures. There are 4 ways to do that:

1. **GitOps-Based Rollback (ArgoCD or FluxCD)**
   - Your deployments are declared in Git (Helm values, Kustomize, YAML)
   - Rollback = revert to a previous Git commit, and ArgoCD syncs it automatically

2. **Docker Image Tag Pinning**
   - Each build pushes an immutable tag (e.g., `myapp:sha-abc123`)
   - Your pipeline records the tag used in prod
   - Rollback = re-deploy old image tag

3. **Helm Rollback**
   - If you use Helm in your CD:
     ```bash
     helm rollback myapp <REVISION_NUMBER>
     ```

4. **Kubernetes Native Rollback**
   - If using raw kubectl:
     ```bash
     kubectl rollout undo deployment/myapp
     kubectl rollout undo deployment/myapp --to-revision=2
     ```

## How do you build the image during CI and how will you manage it?

In our CI/CD pipeline, we build Docker images as part of the CI stage using a Dockerfile stored in the repository. The build is triggered automatically on code changes to specific branches like feature, main, or release.

We use Jenkins as our CI tool, and the Docker image is tagged immutably using the Git commit SHA — for example, `myapp:<commit-sha>` — to ensure traceability and to avoid tag conflicts.

After building, we securely log in to our Docker registry (like Docker Hub or AWS ECR) using credentials stored in Jenkins' credential store. Then we push the tagged image to the registry.

We follow a promotion strategy — instead of rebuilding, we promote the same tested image across environments (dev → staging → pre-prod → prod) by reusing the same SHA-based tag.

This ensures we deploy the exact same image that passed previous environments. We also use lifecycle rules in our registry to clean up older images while retaining production and release tags for auditing.

## What's your organisation's current CI/CD process and tools?

In my current organization, we follow a GitOps-based CI/CD process.

In my current organization, we follow a GitOps-based CI/CD process.

For CI, we use Jenkins for building, testing, and packaging our applications. The pipelines are defined using Jenkinsfile (mostly declarative), and we use multi-branch pipelines to automatically trigger builds on branches like feature, main, and release. Jenkins integrates with Docker to build and tag images using Git commit SHAs, which are then pushed to AWS ECR.

For secret management in Jenkins, we use the Credentials Plugin, and Docker login is handled securely using stored credentials.

 For CD, we use ArgoCD as our GitOps tool. Once Jenkins pushes a Docker image and updates the relevant values.yaml or Kustomize overlays in a Git repo, ArgoCD watches the repo and syncs changes to Kubernetes clusters.

 Our environments are split by Git branches and folders:

 feature → Dev (auto-deploy)

 main → Staging (QA/UAT)

release → Pre-prod & Prod (manual promotion)

We also use Helm for templating our Kubernetes manifests and Terraform for provisioning underlying AWS infrastructure.

Rollbacks are handled either via ArgoCD Git reverts or Helm revision history. We have Slack notifications and approval gates for production deployments.

## How frequently do we deploy to production?

Depends on the project:
- Some: every two weeks
- Some: quarterly

## Have you worked on production deployment activity?
Yes, I’ve been actively involved in production deployment activities in my current role.

We use ArgoCD for GitOps-based deployments to Kubernetes, and all production deployments are done by promoting a tested Docker image tag from pre-prod to prod by updating the Git manifest (values-prod.yaml).

The deployment process includes:
    Validating pre-prod test results (functional, performance, and security checks)
    Updating the image tag in the production overlay or values file
    Triggering ArgoCD to sync the changes to the production cluster
    Monitoring logs, pod health, and dashboard metrics post-deploy (via Prometheus/Grafana and ELK stack)

    For sensitive or high-impact deployments, we use manual approval gates and notify relevant stakeholders via Slack/Teams.

## How do you move code between environments?

**GitOps + CI/CD Based**

We follow a GitOps-driven CI/CD process to move code across environments — from dev → staging → pre-prod → prod.
Code is developed and tested in feature branches and then merged into the appropriate environment-tracking branch:
feature → triggers deployment to dev
main → goes to staging
release → deployed to pre-prod
For moving code to the next environment, we do:
Merge the branch upward (e.g., main into release)
Use Jenkins to build the app, tag the Docker image with the commit SHA, and push it to AWS ECR
Update the relevant GitOps values.yaml file (e.g., values-preprod.yaml or values-prod.yaml) with that exact image tag
ArgoCD automatically syncs the change to the target environment

This approach ensures that we:
 Promote the exact tested image
 Have full traceability through Git history
 Keep environments fully declarative and auditable

For non-GitOps: promote image manually via Helm or kubectl
 We build and tag the Docker image in Jenkins, push it to the registry, and then use environment-specific pipelines or scripts (like Helm or kubectl) to deploy it to the next environment.

We avoid rebuilding the image between environments — we promote the same tag from dev to staging, then to prod.

## Toughest situation faced and lessons learned?

During first prod deployment using GitOps, wrong image deployed due to misconfigured `values-prod.yaml`.
One of the toughest situations I faced was during a production deployment involving a new CI/CD pipeline rollout using Jenkins and ArgoCD.

We were transitioning from manual deployment scripts to a GitOps model, and during the first deployment to production, the pipeline failed due to a misconfigured Helm value in the values-prod.yaml. It ended up deploying the wrong Docker image — not the one tested in pre-prod.

The root cause was that the image tag was hardcoded incorrectly during a manual edit, and there was no automated validation in place to verify image tag consistency across environments.


Lessons:
- Add validation for tag consistency
- Use SHA-based tags only
- Promote, don’t rebuild
- Add checklists and post-deploy testing

## How do you set approval in CD pipeline?

- Use `input` step in Jenkins before production deployment
- Ensures human approval before critical changes go live

## What security measures/tools are used in your CI/CD pipeline?

- **Secrets**: Jenkins credentials + AWS Secrets Manager
- **Code Analysis**: SonarQube
- **Image Scanning**: Trivy
- **Infra Scan**: Checkov
- **Immutability**: Git SHA tags
- **RBAC** + Approval steps
- **Auditing**: GitOps

## How do you handle secrets in CI/CD?

- Jenkins Credentials Plugin (for API keys, tokens, passwords)
- Access via `withCredentials` blocks
- Never expose in logs
- Runtime: use AWS Secrets Manager or Kubernetes Sealed Secrets

## Jenkins Specific

- **What will happen if we have 5 stages in a Jenkins pipeline and the 5th stage has a syntax error?**  
  At Jenkinsfile Parsing Time:  
  If the syntax error is in the pipeline structure (e.g., missing braces, wrong keywords), Jenkins will:
  - Fail the entire pipeline before execution starts
  - Show a "Jenkinsfile parse error" in the build output
  - None of the stages (including stages 1–4) will run

  ⚙️ At Runtime (Inside Stage 5):  
  If the syntax error is inside a script step in stage 5 (e.g., a typo in a shell command or Groovy), then:
  - Stages 1–4 will run successfully
  - Stage 5 will fail during execution
  - The pipeline will mark the build as failed

- **What are the main differences between scripted and declarative pipeline?**  
  The main difference is that Declarative pipelines use a more structured and easy-to-read syntax (`pipeline {}` block), while Scripted pipelines are written in pure Groovy and offer more flexibility and control.

- **Where do you write the code/yaml file for pipeline?**  
  You write the pipeline code or YAML file in your project’s source code repository, usually at the root level, so it can be version-controlled along with your application code.

- **How to schedule a pipeline (validated with some update and want to schedule to stage/main branch)?**  
  To schedule a pipeline (e.g., on the stage or main branch after validation), you can use a cron-like scheduler in your CI/CD tool.  
  Add a `triggers` block with a cron expression.

- **How do you integrate SonarQube & Snyk in Jenkins/Azure pipeline?**  
  1. **Install Plugin:**  
     Install "SonarQube Scanner" plugin in Jenkins.  
  2. **Configure SonarQube Server:**  
     Go to Manage Jenkins → Configure System → SonarQube servers  
     Add your SonarQube server URL and token.  
  3. **Add Sonar Scanner:**  
     Configure in Global Tool Configuration.  
  4. **Use in Jenkinsfile**

- **How do you store sensitive information like passwords in Jenkins?**  
  In Jenkins, we store sensitive information like passwords, tokens, and API keys using the Credentials Plugin. These secrets are saved securely in Jenkins and are encrypted on disk.  
  In the pipeline, we access them using the `withCredentials` block to avoid exposing them in the code or logs. This ensures that secrets are safely injected only when needed and are masked in the console output.

- **How would you structure Jenkins jobs for multiple environments or cloud providers?**  
  Refer your book.

- **Which type of Jenkins file are you using? Can you write a Jenkins file?**  
  I am using declarative JenkinsFile.

- **What did you do with Jenkins?**  
  I’ve worked extensively with Jenkins to design and manage complete CI/CD pipelines for multiple environments.  
  I created declarative pipelines using Jenkinsfile, handled Docker image builds, pushed them to registries like ECR and DockerHub, and automated deployments using Helm, kubectl, and ArgoCD.  
  I also integrated Jenkins with tools like SonarQube for code quality checks, Snyk for security scans, and used the Credentials plugin to securely manage secrets. For production deployments, I implemented manual approval steps, rollback mechanisms, and used shared libraries to reuse common pipeline logic across microservices.

- **How were you authenticating Jenkins to push Docker image to registry?**  
  I authenticated Jenkins to push Docker images by using the Credentials plugin. I stored the Docker registry username and password as a secret (Username/Password) credential in Jenkins.  
  In the Jenkinsfile, I used the `withCredentials` block to securely access those credentials and perform a Docker login before pushing the image.


## Jenkins and Git CI/CD Interview Q&A

### How to configure Jenkins to trigger Pipeline B automatically after Pipeline A?
1. **Use build Step in Pipeline A**  
   In Pipeline A's Jenkinsfile, trigger Pipeline B.

2. **Use "Build Triggers" in Pipeline B**  
   - Go to Pipeline B → Configure  
   - Under Build Triggers, check ✅ *Build after other projects are built*  
   - Enter the name of Pipeline A  
   - This is UI-based and works even without modifying Jenkinsfile.

### Explain how you would set up a multi-branch Jenkins pipeline for a GitHub repository?
(*Answer not provided*)

### How would you implement dynamic stages in a Jenkinsfile based on environment variables?
Use a Scripted Pipeline or `script` blocks inside a Declarative Pipeline to define stages conditionally.
Based on environment variables or parameters, I conditionally define and execute stages. This allows the pipeline to behave differently for different environments like dev, staging, or prod.

### CI/CD pipeline failure investigation steps:
- When a Jenkins pipeline fails, I follow a structured approach to investigate:

    - Check the console output to identify the exact stage and step where the failure occurred. Jenkins logs usually point to a command, script, or syntax issue.

    - If the failure is during a build, I check for compilation errors, dependency issues, or failed tests.

    - If it’s during Docker image build or push, I verify credentials, image tags, and Docker daemon status.

    - If it's a deployment failure, I check Kubernetes logs, Helm error messages, or ArgoCD sync status.

    - I also verify if any recent changes were made to the Jenkinsfile, secrets, or environment variables.

    - If plugins are involved (e.g., SonarQube or Snyk), I check plugin connectivity, credentials, and CLI usage.

### Passing variables from Jenkins:
- **Parameters block**
- **Environment block**
- **Upstream job parameters**
- **Credentials (withCredentials)**

### Jenkins plugins for container registry auth:
- **Credentials Plugin** to store Docker username/password
- In Jenkins, container registry authentication is typically handled using the Credentials  Plugin, which securely stores Docker registry usernames and passwords.

### SonarQube output and issue fixing:
- Reports: bugs, vulnerabilities, smells, duplications
- Fix code smells by refactoring
- Fix vulnerabilities via secure coding practices

### Default Quality Gate in SonarQube:
- "Sonar way":  
  - The default quality gate in SonarQube is called “Sonar way”.
    It ensures that the new code has no bugs, no vulnerabilities, at least 80% code coverage, and less than 3% code duplication.
    The idea is to maintain high quality in new changes without being blocked by legacy code issues

### Jenkins + Artifactory/Nexus:
- Jenkins integrates with Artifactory or Nexus by using dedicated plugins and configured credentials.
- Use JFrog plugin or Maven/Gradle credentials to publish artifacts

### Jenkins post conditions:
- `always`, `success`, `failure`, `unstable`, `changed`

### Notification setup in Jenkins:
- Use **Slack Notification Plugin** or **Email Extension Plugin**
 I configure the plugin in Manage Jenkins, add the webhook URL or SMTP details, and then use notification steps in the post section of the pipeline.

### Terraform auto-approve:
```bash
terraform apply -auto-approve
```

---

## Git Related

### What is PAT (Personal Access Token)?
A secure token used for authenticating tools like Jenkins to services like GitHub/GitLab.
A Personal Access Token (PAT) is a secure, user-specific token used to authenticate with services like GitHub, GitLab, or Azure DevOps without using a password.
It’s often used in CI/CD pipelines to allow Jenkins or other tools to pull code from or push to repositories, and it can have scoped permissions for better security.

### Handling Git merge conflicts:
```bash
git status
# Edit conflict files, then
git add <file>
git commit
```

### Git branching strategy:
- `feature/*` → based on `main` -branches are used for development 
- `main` → staging -main is used for staging deployments and always contains stable,   test-ready code
- `release` → pre-prod/prod -release branch is used for pre-prod and production deployments
- `hotfix/*` → from `release` branches are created from release to fix urgent prod issues

### Git tags:
- Git tags are used to mark specific commits in the repository, usually to indicate release versions like v1.0.0.
- In CI/CD, tags are commonly used to trigger release pipelines, generate versioned artifacts, or deploy specific versions to environments like staging or production.

### git fetch vs pull vs push:
- `fetch` = download only
- `pull` = fetch + merge
- `push` = upload commits

### Recover from force push/deleted branch:
- If a branch was force-pushed or deleted, I try to recover it using the Git reflog
```bash
git reflog
```
To find the commit hash before the force push or deletion, then restore it using:
```bash
git checkout -b <branch> <commit-hash>
```
### Git squash vs rebase:
- **Squash** = combine commits
- **Rebase** = linear history

