# Auto Sandbox

**Auto Sandbox** is an automated Azure infrastructure provisioning and drift-detection project built using **Terraform** and **GitHub Actions**.  
It enables controlled creation of sandbox environments and continuously checks for configuration drift in deployed Azure resources.

Repository: https://github.com/Tanisha-221/Auto_Sandbox

---

## Project Objective

- Provision Azure sandbox infrastructure in a controlled and repeatable way
- Detect configuration drift between Terraform state and actual Azure resources
- Automatically remediate drift only when it is detected
- Support both **manual** and **branch-based** triggers

---

## CI/CD Pipelines Overview

This project uses **two GitHub Actions pipelines**:

1. **Terraform CI/CD Pipeline** – Manual infrastructure creation
2. **Drift Detection Pipeline** – Detects and optionally fixes drift

---

## Pipeline 1: Terraform CI/CD (Infrastructure Creation)

**Workflow name:** `Terraform CICD`

### Trigger
- Manual trigger using `workflow_dispatch`

### Purpose
- Create or update Azure infrastructure on demand
- Used for initial provisioning and controlled changes

### Inputs
| Input | Description |
|-----|-------------|
| `vm_count` | Number of virtual machines to create |
| `prefix` | Resource naming prefix |

### Flow
1. Manual trigger via GitHub Actions
2. Checkout repository
3. Initialize Terraform
4. Authenticate to Azure using Service Principal
5. Generate Terraform plan
6. Store plan as an artifact
7. Apply the Terraform plan
8. Infrastructure is created or updated in Azure

### Result
- Infrastructure is provisioned successfully  
- Terraform state is updated in the backend  

---

## Pipeline 2: Drift Detection Pipeline

**Workflow name:** `Drift Detection Pipeline`

### Triggers
- Push to `main` branch
- Manual trigger (`workflow_dispatch`)

### Purpose
- Detect configuration drift between Terraform configuration and deployed Azure resources
- Automatically apply changes **only if drift is detected**

### Key Behavior
- Uses `terraform plan -refresh-only`
- Does **not** apply changes unless drift exists

### Flow
1. Pipeline triggers on:
   - Code changes in `main`
   - Manual execution
2. Terraform initializes
3. Azure authentication
4. Terraform runs in **refresh-only** mode
5. Exit codes are evaluated:
   - `0` → No drift
   - `2` → Drift detected
6. Terraform plan is saved as an artifact
7. **Apply job runs only if drift is detected**
8. Drift is remediated automatically using `terraform apply`

### Conditional Apply Logic
```text
If drift detected → terraform apply
If no drift → apply is skipped
```

## Workflow Diagram
```
Manual CICD Pipeline
        │
        ▼
Terraform Plan → Terraform Apply → Azure Infrastructure
        │
        ▼
Terraform State Updated
        │
        ▼
──────────────────────────────────────
        │
        ▼
Drift Detection Pipeline
        │
        ▼
terraform plan -refresh-only
        │
        ├── No Drift → Stop
        │
        └── Drift Detected → terraform apply
```  

## Infrastructure Components

The Terraform configuration provisions:
- Azure Resource Group
- Virtual Network & Subnet
- Public IP Addresses
- Network Interfaces
- Virtual Machines (Ubuntu)
- Log Analytics Workspace
- Storage Account (via module)  

## Limitation 
1. Drift Detection Constraint (Ephemeral Runners)  
- GitHub-hosted runners are stateless and ephemeral, meaning:
- No previous plan files are retained
- Drift comparison is always against live Azure state, not a historical plan

As a result:

- Drift detection relies on terraform refresh behavior
- There is no baseline plan file to compare across runs

2. Terraform State Backend  
- If Terraform state is stored locally, drift detection accuracy is limited
- Remote backend (Azure Storage Account) is recommended for production usage

3. Password-Based Authentication  
- VM login uses username/password
- Not recommended for production environments

4. Deprecated Resources  
- azurerm_virtual_machine is used
- Azure recommends azurerm_linux_virtual_machine for newer deployments