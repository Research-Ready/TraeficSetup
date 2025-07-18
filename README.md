# Ansible Playbook for Deploying Services on a Dynamic Infrastructure

This playbook automates the deployment of a suite of services defined in the `TraefikFiles/dynamic` directory using Docker Compose. It is designed to be used in conjunction with a dynamically provisioned server environment, enabling rapid and repeatable deployments.

## Overview

This project aims to provide a flexible and scalable infrastructure for hosting a variety of services. The `TraefikFiles/dynamic` directory contains configuration files for each service, allowing for easy addition, removal, and modification of services. The Ansible playbook orchestrates the deployment of these services using Docker Compose, ensuring consistent and reliable deployments.

## Server Environment

This playbook is intended for use on a server with the following characteristics:

*   **Operating System:** Ubuntu 20.04 or CentOS 7/8 (tested)
*   **Docker:** Docker Engine version 20.10 or higher is required.
*   **Docker Compose:** Docker Compose version 1.29 or higher is required.
*   **Ansible:** Ansible version 2.9 or higher is required.
*   **Network:** The server must have network access to pull Docker images from Docker Hub or other configured registries.
*   **Firewall:** Ensure that the necessary ports are open in the firewall to allow access to the deployed services.

## Prerequisites

- **Docker and Docker Compose:** Must be installed on the target machine. You can download and install them from [https://www.docker.com/](https://www.docker.com/). Follow the official installation instructions for your operating system.
- **Ansible:** Must be installed on the control machine (the machine you're running the playbook from).

## Installing Ansible

Before you can run the playbook, you need to install Ansible on the control machine.

### On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install ansible
```

### On CentOS/RHEL:
```bash
sudo yum install epel-release
sudo yum install ansible
```

### Verify Installation:
```bash
ansible --version
```

## Network Topology and IP Address Allocation

The following diagram illustrates the network topology of the deployed services:

```
+-----------------+      +-----------------+
|     Server      |------|   Traefik Proxy |  (10.0.4.1)
+-----------------+      +-----------------+
       | eth0 (192.168.1.100)
       |
+-----------------+      +-----------------+      +-----------------+
| Development     |------|   Service 1     |  (10.0.5.2)
| Network (10.0.5.0/24)|      +-----------------+      +-----------------+
+-----------------+
       |
+-----------------+      +-----------------+
| Test Network    |------|   Service 2     |  (10.0.6.2)
| (10.0.6.0/24)   |      +-----------------+
+-----------------+
       |
+-----------------+      +-----------------+
| Acceptance       |------|   Service 3     |  (10.0.7.2)
| Network (10.0.7.0/24)|      +-----------------+
+-----------------+
       |
+-----------------+      +-----------------+
| Production       |------|   Service 4     |  (10.0.8.2)
| Network (10.0.8.0/24)|      +-----------------+
+-----------------+
```

**IP Address Allocation:**

*   **Server:** 192.168.1.100 (Static IP)
*   **Traefik Proxy:** 10.0.4.1
*   **Development Network:** 10.0.5.0/24 (Service IPs start at 10.0.5.2)
*   **Test Network:** 10.0.6.0/24 (Service IPs start at 10.0.6.2)
*   **Acceptance Network:** 10.0.7.0/24 (Service IPs start at 10.0.7.2)
*   **Production Network:** 10.0.8.0/24 (Service IPs start at 10.0.8.2)

## Step-by-Step Deployment Instructions

1.  **Prepare the Server:** Ensure your server meets the prerequisites listed above. Install Docker, Docker Compose, and Ansible.
2.  **Clone the Repository:** Clone this repository to your control machine: `git clone https://github.com/Research-Ready/TraeficSetup.git`
3.  **Navigate to the Project Directory:** `cd TraeficSetup`
4.  **Create Docker Compose Files:** For each service you want to deploy, create a `docker-compose-*.yml` file in the `Ansible` directory. Use the example `docker-compose-service1.yml` as a template.
5.  **Customize Docker Compose Files:** Modify the `docker-compose-*.yml` files to configure each service according to its specific requirements.
6.  **Run the Ansible Playbook:** Execute the following command to deploy the services: `ansible-playbook Ansible/playbook.yml`
7.  **Verify the Deployment:** After the playbook completes, verify that the services are running correctly by checking the Docker containers: `docker ps`

## Example docker-compose.yml (for service1):

```yaml
version: "3.9"
services:
  service1:
    image: nginx:latest  # Example: Using the official nginx image
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html  # Example: Mounting a local directory to serve static content
```

## Important Notes:

*   **Docker Images:** You need to have the Docker images for each service available on the target machine. You can pull them from Docker Hub or build them yourself.
*   **Configuration:** The specific configuration options for each service will vary depending on the service itself. Refer to the service's documentation for more information.
*   **Error Handling:** If you encounter any errors during the playbook execution, check the Ansible output for details.
*   **Networking:**  Consider using Docker networks to isolate your services and improve security.
