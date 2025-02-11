# WordPress App in k3s using Terraform IaC

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Deployment Steps](#deployment-steps)
   - [Step 1: Set Up Terraform Configuration](#step-1-set-up-terraform-configuration)
   - [Step 2: Initialize and Apply Terraform Configuration](#step-2-initialize-and-apply-terraform-configuration)
   - [Step 3: Verify the Deployment](#step-3-verify-the-deployment)
   - [Step 4: Access Your WordPress Application](#step-4-access-your-wordpress-application)
4. [Screenshots](#screenshots)
5. [Conclusion](#conclusion)
6. [References](#references)

---

## Introduction
This document outlines the process of deploying a **WordPress application** on a lightweight Kubernetes cluster (**k3s**) using **Terraform as Infrastructure as Code (IaC)**. The k3s cluster is deployed on an **Amazon Linux 2 EC2 instance**, and the WordPress application is managed using Kubernetes manifests.

All Terraform and Kubernetes configuration files are located in the [`Codes/`](./Codes/) directory.

---

## Prerequisites
Before proceeding, ensure you have the following:

1. **AWS Account**: An active AWS account with permissions to create EC2 instances.
2. **Terraform**: Terraform installed on your local machine. Download it from [here](https://www.terraform.io/downloads.html).
3. **SSH Key Pair**: An SSH key pair for accessing the EC2 instance. You can create one in the AWS Management Console.
4. **Basic Knowledge**: Familiarity with Kubernetes, Terraform, and AWS EC2.

---

## Deployment Steps

### Step 1: Set Up Terraform Configuration
1. Navigate to the [`Codes/`](./Codes/) directory.
2. Review the following files:
   - **`main.tf`**: Defines the AWS provider and the EC2 instance with k3s installed.
   - **`deployment.yaml`**: Kubernetes manifest for deploying the WordPress application.
   - **`service.yaml`**: Kubernetes manifest for exposing the WordPress application.
   
   These files are pre-configured and ready to use.

---

### Step 2: Initialize and Apply Terraform Configuration
 ### **1. Initialize Terraform**:
   ```bash
   terraform init
   ```

   ### **2. Validate Configuration**
```sh
terraform validate
```

### **3. Plan Deployment**
```sh
terraform plan
```

### **4. Apply Configuration**
```sh
terraform apply -auto-approve
```

### **5. View Created Resources**
```sh
terraform show
```

### **6. Wait for the EC2 instance to be provisioned and k3s to be installed.**

---

### Step 3: Verify the Deployment
1. SSH into the EC2 instance:
   ```bash
   ssh -i your-key.pem ec2-user@<instance-public-ip>
   ```
2. Check the status of Kubernetes pods:
   ```bash
   kubectl get pods -n wordpress
   ```
3. Ensure all pods are running successfully.

---

### Step 4: Access Your WordPress Application
1. Retrieve the external IP of the WordPress service:
   ```bash
   kubectl get svc -n wordpress
   ```
2. The WordPress application is exposed on NodePort 31111.

3. An inbound rule has been added to the security group to allow traffic on port 31111.

4. Open a web browser and navigate to http://<external-ip>:31111 to complete the WordPress setup.
   
---

## Screenshots


![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/1.png)


Initializing and Validating Terraform files


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/2.png)


Plan deployment


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/3.png)


Apply Configuration


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/4.png)


Apply Completed Successfully


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/5.png)


Showing Configuration


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/6.png)


Ec2 Instance Public IP details


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/7.png)


Accessing Web App


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/8.png)


Instance details from the AWS Console


---

![Alt text of the image](https://github.com/BasilTAlias/Wordpress-App-in-K3-using-Terraform-IaC/blob/main/images/9.png)


Checking Pods details using Kubectl


---

## Conclusion
Through this deployment, I successfully set up a WordPress application on a k3s cluster using Terraform, reinforcing my understanding of Infrastructure as Code (IaC) and Kubernetes orchestration. By provisioning an EC2 instance, configuring k3s, and deploying WordPress with Kubernetes manifests, I gained practical experience in automating cloud infrastructure. Additionally, exposing the application via NodePort 31111 and configuring security group rules enhanced my knowledge of networking and access control in AWS. This project strengthened my skills in Terraform, Kubernetes, and cloud automation, demonstrating the efficiency of declarative infrastructure management for scalable and reproducible deployments in cloud-native environments.

---

## References
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [K3s Documentation](https://k3s.io)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

