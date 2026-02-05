---
layout: page
title: Version 1 Auto Sandbox Readme
---

# Auto_Sndbox
The Auto Sandbox project is designed to automate the provisioning and management of infrastructure on Microsoft Azure using Terraform. This project utilizes GitHub Actions for continuous integration and continuous deployment (CI/CD) to automate the entire lifecycle of infrastructure management, from creation to monitoring.

## Key Features of the Auto Sandbox Project

Infrastructure as Code (IaC) with Terraform:
The project leverages Terraform to define and provision cloud resources in an automated and consistent manner. Terraform configurations define key resources such as virtual machines, networking, storage, monitoring, and alerting.

* Automated Resource Provisioning:
The Terraform configuration is designed to create various Azure resources, including:
* Resource Groups for organizing resources.
* Virtual Networks and Subnets for networking.
* Virtual Machines (VMs) with network interfaces and public IP addresses.
* Log Analytics Workspaces to collect and analyze logs and metrics from deployed resources.
* Monitor Diagnostic Settings to enable monitoring on virtual machines.
* Action Groups to send notifications (e.g., to Slack) when alerts are triggered.

## CI/CD Pipeline with GitHub Actions:
The project integrates GitHub Actions to automate the deployment process:
* Continuous Integration (CI) pipeline: Triggered by commits to the main branch. It handles tasks like initializing and validating Terraform configurations, generating Terraform plans, and ensuring that the desired state matches the actual infrastructure.
* Continuous Deployment (CD) pipeline: Triggered by the completion of the CI pipeline, this deploys the infrastructure by applying the Terraform plan and automatically sends Slack notifications upon success or failure.

## Slack Notifications:
The Azure Monitor Action Group is used to send Slack notifications whenever there is an important update, such as infrastructure changes or alert triggers. This helps keep teams informed in real-time about the status of infrastructure deployments.

## Monitoring and Logging:
The project integrates Azure Monitor and Log Analytics to track infrastructure performance, detect anomalies, and gather detailed logs and metrics. This provides visibility into the health and performance of deployed virtual machines and other resources.

## Drift Detection:
Future plans for the project include enabling drift detection to ensure the infrastructure state is always in sync with the declared Terraform configurations. This will be done using scheduled Terraform plans to detect any discrepancies or manual changes to the infrastructure.

## Error Handling and Conflict Resolution:
The project is designed to handle and resolve conflicts that arise during the provisioning of resources, such as errors with Azure resources that are already in use (e.g., shared log analytics workspaces or action groups). Error messages are captured, and the Terraform state is updated to reflect the actual infrastructure state.

## Why is This Project Important?

The Auto Sandbox project provides an automated, repeatable, and consistent approach to managing Azure infrastructure. Key benefits include:

- Infrastructure Automation: Reduces manual intervention and the risk of human error in provisioning and managing cloud resources.
- Scalability: Easily scale infrastructure with minimal changes to the configuration, making it suitable for dynamic environments.
- Real-Time Notifications: Stay informed about infrastructure changes and issues through Slack notifications.
- Centralized Monitoring: Collect and analyze logs from all deployed resources in a centralized Log Analytics Workspace.
- Continuous Integration/Continuous Deployment (CI/CD): Automate the entire process of infrastructure provisioning, ensuring that changes are tested and deployed in a controlled and consistent manner.
- Compliance and Audit: The use of Terraform and Azure Monitor ensures that infrastructure changes are tracked and auditable, providing visibility for compliance and governance.

## Flow Diagram 
![alt text](version1.png)
![alt text](<version 2.png>)

## Steps You Performed
1. Created Terraform Configuration Files
You created a Terraform configuration to manage your Azure infrastructure. This configuration defines the resources to be created, such as:
- Resource Group: Created an Azure Resource Group to logically group resources.
- Virtual Network: Defined a Virtual Network with a specific address space.
- Subnet: Created a subnet within the Virtual Network.
- Public IP: Set up static public IP addresses for virtual machines.
- Virtual Machines: Defined the creation of VMs, with network interfaces and storage configurations.
- Log Analytics Workspace: Created a Log Analytics Workspace to collect logs and metrics.
- Monitor Diagnostic Settings: Configured monitoring for virtual machines, including logging metrics to the Log Analytics workspace.
- Monitor Action Group: Created a Monitor Action Group to send Slack notifications when a monitoring alert is triggered.  
[Click here for the terraform file](https://github.com/Tanisha-221/Auto_Sandbox/tree/main/tf_Config)

2. Configured Variables

You defined variables for reusable values in your variables.tf file, such as:

- Prefix: Used to prefix the names of all resources.
- VM Count: Number of virtual machines to create.
- Admin Credentials: Defined the admin username and password for VM access (using environmemt variable na dstored in secret for github ).
- Service URL: Used in the monitor action group to send notifications to Slack.  
[Click here for variable file](https://github.com/Tanisha-221/Auto_Sandbox/blob/main/tf_Config/variable.tf)

3. Set Up GitHub Actions CI/CD Pipelines

You configured GitHub Actions workflows for continuous integration and deployment:

CI Pipeline:
- Triggered by a push to the main branch.
- Set up to initialize and forat Terraform configurations.
- Plan the infrastructure changes.

CD Pipeline:

- Triggered by the completion of the CI pipeline.
- Deploy the infrastructure by applying the Terraform plan.
- Send notifications on Slack regarding the deployment status.

[Click here for workflows](https://github.com/Tanisha-221/Auto_Sandbox/tree/main/.github/workflows)

4. Configured Slack Notification Action Group

You set up a Slack webhook to send notifications to a specified Slack channel when certain actions or alerts occur in your Azure Monitor.
Create a Slack Incoming Webhook

### Before you can integrate Slack with Grafana, you need to create an Incoming Webhook in your Slack workspace.

- Go to Slack App Directory:
- Visit the Slack App Directory at: [Slack Incoming Webhooks](https://notification-aod8335.slack.com/marketplace/A0F7XDUAZ-incoming-webhooks)
- Add the Incoming Webhook App:
- Search for "Incoming Webhooks" in the search bar.
- Click on the Add to Slack button.
- Choose a Slack Channel:
- Select the Slack channel where you want Grafana notifications to be sent.
- After selecting the channel, click on Add Incoming Webhooks Integration.
- Get the Webhook URL:
- After the integration is added, you will be provided with a Webhook URL.
- Used the azurerm_monitor_action_group resource to define the webhook for Slack.
- Configured the service URL for Slack to post alerts to a specific channel.

5. Addressed Resource Conflicts

I encountered an issue with conflicting resources in the Monitor Diagnostic Settings (due to reused data sinks across multiple settings). To resolve it:

- Removed duplicate diagnostic settings.
- Ensured that each diagnostic setting has a unique name.

## Future Enhancement 

1. **Enhanced Alerts and Automation**
2. **Improved CI/CD Integration**
3. **Security & Cost Monitoring**
4. **Scalability & High Availability**
