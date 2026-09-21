# Static Website Deployment on Kubernetes using Docker, K3s, Nginx, and AWS EC2

## Project Overview

This project demonstrates how I containerized an HTML-based static website using Docker and Nginx, deployed it to a single-node Kubernetes cluster using K3s on an AWS EC2 instance, and exposed it publicly through a Kubernetes NodePort Service.

During the implementation, I also troubleshot real-world issues involving insufficient disk space, Docker image-name mismatch, kubeconfig permissions, Linux directory permissions, and a port conflict caused by the default K3s Traefik ingress controller.

## Project Objectives

- Host an HTML, CSS, and JavaScript website using Nginx
- Package the website as a Docker image
- Install a lightweight Kubernetes cluster using K3s
- Deploy the container as a Kubernetes Pod managed by a Deployment
- Expose the application publicly with a NodePort Service
- Validate the deployment using Docker, kubectl, curl, and browser testing
- Document errors, root causes, and resolutions

## Architecture

```text
Developer workstation
        |
        | SSH using PuTTY
        v
AWS EC2 Ubuntu instance
        |
        +-- Docker
        |     +-- Builds the Nginx website image
        |
        +-- K3s Kubernetes cluster
              |
              +-- Deployment
              |     +-- Pod
              |           +-- Nginx container
              |                 +-- Static website files
              |
              +-- NodePort Service :30080
                        |
                        v
              Internet users via
        http://<EC2-PUBLIC-IP>:30080
```

## Technology Stack

- AWS EC2
- Ubuntu Linux
- PuTTY
- Git and GitHub
- Docker
- Nginx
- K3s
- Kubernetes
- kubectl
- YAML

## Application Structure

```text
website/
├── css/
├── img/
├── js/
├── index.html
├── product.html
├── Dockerfile
├── deployment.yaml
├── service.yaml
└── README.md
```

## Prerequisites

- An AWS EC2 Ubuntu instance
- SSH access to the instance
- EC2 Security Group access to:
  - TCP 22 from a trusted administration IP
  - TCP 30080 from the required client range
- A static website containing an `index.html` file
- Sufficient disk capacity for Ubuntu, Docker images, K3s images, and container layers

> Security note: `0.0.0.0/0` makes a port reachable from any IPv4 address. For production workloads, restrict access where possible and use HTTPS with a domain name and an ingress or load balancer.

---

## 1. Connect to the EC2 Instance

Connect using PuTTY with the EC2 public IPv4 address and log in as the Ubuntu user.

```bash
ssh ubuntu@<EC2-PUBLIC-IP>
```

Verify the current directory and operating system:

```bash
pwd
cat /etc/os-release
```

## 2. Update Ubuntu

```bash
sudo apt update
sudo apt upgrade -y
```

## 3. Install Docker

```bash
curl -fsSL https://get.docker.com | sh
```

Verify the installation:

```bash
docker --version
sudo systemctl status docker
```

If the Ubuntu user does not have permission to run Docker commands:

```bash
sudo usermod -aG docker ubuntu
newgrp docker
```

## 4. Install K3s Kubernetes

```bash
curl -sfL https://get.k3s.io | sh -
```

Verify the K3s node:

```bash
sudo k3s kubectl get nodes
```

Expected state:

```text
STATUS: Ready
ROLES: control-plane
```

## 5. Configure kubectl for the Ubuntu User

K3s creates its kubeconfig at `/etc/rancher/k3s/k3s.yaml`. The following commands copy it to the standard kubectl location and assign ownership to the current user.

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown "$USER":"$USER" ~/.kube/config
```

Validate the configuration:

```bash
kubectl get nodes
kubectl get pods -A
```

## 6. Prepare the Website Directory

Work inside the Ubuntu user's home directory rather than the root filesystem.

```bash
cd ~
mkdir -p website
cd website
pwd
ls -la
```

The expected working directory is:

```text
/home/ubuntu/website
```

Upload the website files to this directory using WinSCP, SCP, Git, or another secure file-transfer method.

## 7. Create the Dockerfile

Create a file named exactly `Dockerfile`. Linux filenames are case-sensitive.

```dockerfile
FROM nginx:latest

COPY . /usr/share/nginx/html

EXPOSE 80
```

Confirm the filename and content:

```bash
ls -la
cat Dockerfile
```

If the file was accidentally created as `dockerfile`, rename it:

```bash
mv dockerfile Dockerfile
```

## 8. Build the Docker Image

Run the command from the directory containing the Dockerfile and website files.

```bash
docker build -t mysite:v1 .
```

The final dot means that the current directory is the Docker build context.

Verify the image:

```bash
docker images
```

## 9. Test the Website with Docker

```bash
docker run -d --name mysite -p 80:80 mysite:v1
```

Verify the container:

```bash
docker ps
curl http://localhost
curl http://localhost/index.html
```

Inspect the files copied into the Nginx document root:

```bash
docker exec -it mysite ls -la /usr/share/nginx/html
```

Review logs:

```bash
docker logs mysite
```

A successful local request should return HTTP status `200` and the content of `index.html`.

## 10. Import the Docker Image into K3s

Docker and K3s use separate image stores in this setup. Save the Docker image and import it into the K3s containerd image store.

```bash
docker save mysite:v1 -o mysite.tar
sudo k3s ctr images import mysite.tar
```

Verify the imported image:

```bash
sudo k3s ctr images list | grep mysite
```

Optional cleanup after confirming the import:

```bash
rm -f mysite.tar
```

## 11. Create the Kubernetes Deployment

Create `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysite
  labels:
    app: mysite
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysite
  template:
    metadata:
      labels:
        app: mysite
    spec:
      containers:
        - name: mysite
          image: docker.io/library/mysite:v1
          imagePullPolicy: Never
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```

`imagePullPolicy: Never` tells Kubernetes to use the image imported into K3s instead of attempting to pull it from an external registry.

Apply the Deployment:

```bash
kubectl apply -f deployment.yaml
```

Verify the rollout and Pod:

```bash
kubectl rollout status deployment/mysite
kubectl get deployments
kubectl get pods -o wide
```

## 12. Create the Kubernetes NodePort Service

Create `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysite-service
spec:
  type: NodePort
  selector:
    app: mysite
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
```

Apply the Service:

```bash
kubectl apply -f service.yaml
```

Verify it:

```bash
kubectl get service mysite-service
kubectl describe service mysite-service
kubectl get endpoints mysite-service
```

## 13. Configure the AWS Security Group

Add an inbound rule to the Security Group attached to the EC2 instance:

```text
Type: Custom TCP
Port: 30080
Source: 0.0.0.0/0
```

For IPv6 access, add `::/0` only if IPv6 is configured and intentionally required.

For production use, avoid exposing the entire Kubernetes NodePort range unless required. This project uses only TCP port `30080`.

## 14. Access the Website

Open the following address in a browser:

```text
http://<EC2-PUBLIC-IP>:30080
```

The request flow is:

```text
Browser
  -> EC2 public IP on TCP 30080
  -> Kubernetes NodePort Service
  -> Pod port 80
  -> Nginx
  -> index.html
```

## 15. Final Validation Commands

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods -o wide
kubectl get services
kubectl get endpoints mysite-service
kubectl logs deployment/mysite
curl http://localhost:30080
```

---

# Troubleshooting and Root-Cause Analysis

## Issue 1: Permission Denied While Creating the Website Directory

### Error

```text
mkdir: Permission denied
```

### Cause

The command was executed from `/`, the root filesystem directory. The regular Ubuntu user cannot create directories directly under `/`.

### Diagnosis

```bash
pwd
```

The output was:

```text
/
```

### Resolution

Move to the Ubuntu user's home directory:

```bash
cd ~
mkdir website
cd website
```

### Learning

Use `/home/ubuntu` for project files. Do not use `sudo` to bypass permissions when the correct solution is to work in the user's home directory.

---

## Issue 2: Permission Denied When Entering the K3s YAML Path

### Error

```text
-bash: /etc/rancher/k3s/k3s.yaml: Permission denied
```

### Cause

`/etc/rancher/k3s/k3s.yaml` is a file, not a command or directory. Typing the path directly asks Bash to execute the file.

### Resolution

Copy the file to kubectl's standard configuration location:

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown "$USER":"$USER" ~/.kube/config
kubectl get nodes
```

### Learning

A kubeconfig file provides cluster connection and authentication details to kubectl. It is read by kubectl rather than executed.

---

## Issue 3: Dockerfile Naming Problem

### Symptom

The build did not initially use the intended Dockerfile because it was named `dockerfile` with a lowercase `d`.

### Resolution

```bash
mv dockerfile Dockerfile
```

### Learning

Linux filenames are case-sensitive. Docker looks for a file named `Dockerfile` by default.

---

## Issue 4: Missing Docker Build Context

### Incorrect command

```bash
docker build -t mysite:v1
```

### Correct command

```bash
docker build -t mysite:v1 .
```

### Learning

The dot supplies the current directory as the build context, allowing Docker to access the Dockerfile and website files used by `COPY`.

---

## Issue 5: Docker Build Failed During `COPY`

### Error location

```text
COPY . /usr/share/nginx/html
```

The build failed while containerd attempted to write an image layer.

### Diagnosis

```bash
df -h
```

The root filesystem showed approximately:

```text
Size: 6.7G
Used: 6.6G
Available: 80M
Usage: 99%
```

Additional investigation:

```bash
docker system df
sudo du -sh /* 2>/dev/null | sort -hr
```

Large directories included `/var`, `/usr`, `/snap`, and `/home`. Docker and Kubernetes images and snapshots contributed to storage consumption.

### Cleanup performed

```bash
docker system prune -a -f
docker builder prune -a -f
df -h
```

### Long-term recommendation

Increase the EC2 root EBS volume before doing extended Docker and Kubernetes practice. After modifying an EBS volume, verify the device and filesystem using `lsblk` and the appropriate AWS/Linux filesystem expansion procedure.

### Learning

The line displayed by Docker identifies where the build failed, but it does not always mean the Dockerfile instruction is incorrect. System resources such as storage must also be checked.

---

## Issue 6: Docker Tried to Pull a Nonexistent Image

### Error

```text
Unable to find image 'static-site:v1' locally
pull access denied for static-site
repository does not exist or may require 'docker login'
```

### Cause

The built image was named `mysite:v1`, but the run command used `static-site:v1`.

### Diagnosis

```bash
docker images
```

### Resolution

Use the exact repository and tag shown by `docker images`:

```bash
docker run -d --name mysite -p 80:80 mysite:v1
```

### Learning

Docker image references must match the repository name and tag exactly.

---

## Issue 7: Public IP Returned `404 page not found`

### Symptoms

- The Docker container was running.
- Port mapping showed `0.0.0.0:80->80/tcp`.
- `curl http://localhost` returned the website.
- Nginx logs showed successful `200` responses.
- Access through the EC2 public IP on port 80 returned `404 page not found`.

### Diagnostic commands

```bash
curl http://localhost
curl http://localhost/index.html
docker logs mysite
docker exec -it mysite ls -la /usr/share/nginx/html
sudo ss -tulpn | grep :80
kubectl get pods -A
docker inspect mysite | grep IPAddress
```

### Root cause

K3s installed Traefik as its default ingress controller. Requests reaching the Traefik entry point without a matching ingress route returned Traefik's `404 page not found` response. The application itself was healthy.

### Resolution used in this project

The website was deployed to Kubernetes and exposed using a NodePort Service on TCP port `30080`:

```text
http://<EC2-PUBLIC-IP>:30080
```

The EC2 Security Group was updated to allow TCP port `30080`.

### Learning

A `404` proves that an HTTP server responded. It is different from a timeout or connection refusal. The response style and server logs help identify which component answered the request.

---

## Issue 8: Docker and K3s Could Not Automatically Share the Local Image

### Cause

The image was built in Docker's image store, while K3s used its own containerd image store.

### Resolution

```bash
docker save mysite:v1 -o mysite.tar
sudo k3s ctr images import mysite.tar
```

The Deployment used:

```yaml
image: docker.io/library/mysite:v1
imagePullPolicy: Never
```

### Learning

A locally built Docker image is not automatically available to every container runtime. For larger or multi-node environments, publish versioned images to a registry such as Amazon ECR instead of manually importing archives.

---

# Useful Operational Commands

## Docker

```bash
docker --version
docker images
docker ps
docker ps -a
docker logs mysite
docker exec -it mysite ls -la /usr/share/nginx/html
docker system df
```

## Kubernetes

```bash
kubectl get nodes
kubectl get pods -A
kubectl get deployments
kubectl get services
kubectl describe deployment mysite
kubectl describe pod <POD-NAME>
kubectl logs deployment/mysite
kubectl rollout status deployment/mysite
```

## Linux and networking

```bash
pwd
ls -la
df -h
sudo du -sh /* 2>/dev/null | sort -hr
sudo ss -tulpn | grep :80
curl http://localhost
curl http://localhost:30080
```

# Updating the Website

After changing website files, build a new version instead of overwriting `v1`:

```bash
docker build -t mysite:v2 .
docker save mysite:v2 -o mysite-v2.tar
sudo k3s ctr images import mysite-v2.tar
```

Update the Deployment:

```bash
kubectl set image deployment/mysite mysite=docker.io/library/mysite:v2
kubectl rollout status deployment/mysite
```

Rollback if required:

```bash
kubectl rollout undo deployment/mysite
```

# Cleanup

Delete the Kubernetes resources:

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```

Remove the Docker test container if it still exists:

```bash
docker stop mysite 2>/dev/null || true
docker rm mysite 2>/dev/null || true
```

Remove local images only when they are no longer required:

```bash
docker image rm mysite:v1
```

# Key Skills Demonstrated

- Linux server administration
- EC2 connectivity and Security Group configuration
- Docker image creation and container execution
- Nginx static content hosting
- K3s installation and kubeconfig configuration
- Kubernetes Deployment and Service creation
- YAML manifest authoring
- Container runtime image import
- Port and process inspection
- Disk-space analysis and cleanup
- Layered troubleshooting across browser, AWS networking, host ports, Docker, Kubernetes, Traefik, Nginx, and application files

# Future Enhancements

- Store the Docker image in Amazon ECR
- Automate build and deployment with GitHub Actions
- Use a domain name instead of a raw public IP
- Configure Kubernetes Ingress with Traefik
- Enable HTTPS using a valid TLS certificate
- Add readiness and liveness probes
- Add CPU and memory requests and limits
- Use multiple replicas and validate self-healing
- Provision the infrastructure using Terraform
- Add monitoring and centralized logging

# Outcome

The static website was successfully containerized with Nginx, deployed to a K3s Kubernetes Pod on AWS EC2, exposed with a NodePort Service, and accessed publicly through the EC2 public IP and port `30080`.
