  # Automated CI/CD Pipeline with Terraform, Ansible, and Jenkins

This project demonstrates the creation of a *CICD (Continuous Integration and Continuous Deployment) pipeline* using *Terraform, Ansible, Docker, and Jenkins*. The infrastructure is provisioned using Terraform, configured using Ansible, and the pipeline is automated using Jenkins and Docker.

## 1. Terraform Setup

### Terraform Init
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/terraform-1.jpg" width="600" height="350">
</p>

****Description:****
The terraform init command initializes the working directory and downloads the necessary provider plugins (e.g., AWS provider) to manage the resources.

****Why it’s important:****
This step ensures Terraform is ready to create and manage the infrastructure defined in the configuration files.

### Terraform Plan
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/tf-2.jpg" width="600" height="350">
</p>

****Description:****
The terraform plan command provides an execution plan, showing what resources will be created, updated, or deleted.

****Why it’s important:****
This step helps verify the configuration before applying any changes, ensuring no unintended modifications are made.

### Terraform Apply
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(49).png" width="600" height="350">
</p>

****Description:****
The terraform apply command creates the actual resources in AWS as defined in the Terraform configuration.

****Why it’s important:****
This step provisions the infrastructure, including EC2 instances, VPC, subnets, and security groups.

## 2. Resources Created by Terraform

### EC2 Instances  
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(50).png" width="600" height="350">
</p>

****Description:****
Two EC2 instances were created:
- *docker server*: Hosts Docker for containerized applications.
- *jenkins server*: Hosts Jenkins for the CICD pipeline.
  
The screenshot shows their public IPs, instance types, and statuses.

****Why it’s important:****
These instances form the backbone of the CICD pipeline, hosting Docker and Jenkins.

### VPC & Components
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(51).png" width="600" height="350">
</p>

****Description:****
A *Virtual Private Cloud (VPC)* named my_vpc was created, along with a route table, internet gateway, and subnet.

****Why it’s important:****
The VPC provides an isolated network environment for the EC2 instances, ensuring secure communication.

### Security Group
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(53).png" width="600" height="350">
</p>

****Description:****
A *security group* was created to control inbound and outbound traffic for the EC2 instances.

****Why it’s important:****
Security groups act as virtual firewalls, ensuring only authorized traffic can access the instances.

### Key Pair
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(54).png" width="600" height="350">
</p>

****Description:****
A *key pair* named CICD.pem was generated and downloaded for SSH access to the EC2 instances.

****Why it’s important:****
The key pair ensures secure SSH access to the instances without using passwords.

## 3. Ansible Setup

### Inventory File
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(56).png" width="600" height="350">
</p>

****Description:****
The inventory.ini file defines the target servers (EC2 instances) for Ansible. The command below was used to ping the servers and verify connectivity:

```bash
ansible all -m ping -i inventory.ini
```

****Why it’s important:****
The inventory file is essential for Ansible to know which servers to manage.

### Install Docker
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(57).png" width="600" height="350">
</p>

****Description:****
The docker_install.yml playbook was executed to install Docker on the target servers.

****Why it’s important:****
Docker is required to containerize and deploy applications.

### Install Jenkins
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(58).png" width="600" height="350">
</p>

****Description:****
The jenkins_install.yml playbook was executed to install Jenkins on the jenkins server instance.

#### Steps in the playbook:
1. Install Java (required for Jenkins).
2. Add Jenkins repository and install Jenkins.
3. Start and enable the Jenkins service.

****Why it’s important:****
Jenkins automates the CICD pipeline, enabling continuous integration and deployment.

## 4. Jenkins Setup

### Jenkins Access
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(59).png" width="600" height="350">
</p>

****Description:****
Jenkins was accessed via the browser using the public IP of the jenkins server instance on port 8080. The admin password was retrieved and entered to unlock Jenkins.

****Why it’s important:****
This step ensures Jenkins is properly installed and accessible.

### Plugin Installation
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(61).png" width="600" height="350">
</p>

****Description:****
Required plugins (*Docker, Pipeline, Git*) were installed on Jenkins.

****Why it’s important:****
Plugins extend Jenkins functionality, enabling integration with Docker, Git, and other tools.

### Adding Credentials in Jenkins  
### Navigating to Jenkins Credentials
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(63).png" width="600" height="350">
</p>

****Description:****  
Navigate to **Manage Jenkins → Credentials → Global Credentials** to add required credentials.

---

### Docker & SSH Credentials in Jenkins
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(64).png" width="600" height="350">
</p>

****Description:****  
- **Docker Hub credentials** were added to enable Jenkins to push/pull images securely.  
- **PEM key file (CICD.pem)** was added as a **SSH-pem key** to allow SSH access to AWS EC2 instances.  

****Why it’s important:****  
- Jenkins needs **Docker Hub authentication** to interact securely with container registries.  
- The **PEM key file** ensures secure SSH access for deployment tasks on AWS.  


### Pipeline Creation
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(66).png" width="600" height="350">
</p>
****Description:****
A pipeline named *Auto-Deploy Pipeline* was created. The Groovy script for the pipeline was written, applied, and saved.

****Why it’s important:****
The pipeline automates the build, test, and deployment process.

### Build Pipeline
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(67).png" width="600" height="350">
</p>

****Description:****
The pipeline was executed by clicking *Build Now*, and it ran successfully.

****Why it’s important:****
This step verifies that the pipeline is working as expected.

## 5. Docker Setup

### Docker Access
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(68).png" width="600" height="350">
</p>

****Description:****
Verified that Docker is accessible on port 80 using the public IP of the docker server instance.

****Why it’s important:****
Ensures Docker is running and accessible for deploying applications.

### Docker Image Build
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(71).png" width="600" height="350">
</p>

****Description:****
Checked the Docker account to confirm that the image was built successfully.

****Why it’s important:****
Ensures the application is containerized and ready for deployment.

### Docker Swarm Replicas
*Screenshot:* <p align="center">
  <img src="https://github.com/22MH1A42H7/Devops-Projects/blob/main/Auto-Deploy/Snapshots/Screenshot%20(70).png" width="600" height="350">
</p>

****Description:****
Verified the replicas created using Docker Swarm with the command:

```bash
ansible -i inventory.ini docker_host -m command -a "sudo docker ps"
```

****Why it’s important:****
Ensures the application is running in a highly available and scalable manner.

## Conclusion
This project successfully demonstrates the automation of *infrastructure provisioning using Terraform, **configuration management using Ansible, and **CICD pipeline setup using Jenkins and Docker*. The pipeline ensures seamless integration and deployment of applications.

## Author

****Satya Praveen M****  
Cloud and Devops Enthusiast  
- **LinkedIn**: [https://www.linkedin.com/in/Satya Praveen M](https://www.linkedin.com/in/satya-praveen-m-36442725b/)  
- **GitHub**: [https://github.com/Satya Praveen M](https://github.com/22MH1A42H7)  

---
