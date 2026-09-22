# Running a Kubernetes Deployment with Minikube on an EC2 Instance

## Overview

This exercise demonstrates how to:

- Expand an EC2 root EBS volume.
- Create a Minikube cluster using Docker.
- Deploy an NGINX application.
- Watch Pods being created.
- Verify the relationship between a Deployment, ReplicaSet, and Pods.
- Open a shell inside a Pod.
- Clean up Kubernetes and Docker resources.

## 1. Check EC2 Disk Space

Check the available disk space:

```bash
df -h
lsblk
```

The root filesystem initially showed approximately 6.7 GB. Minikube and its container image require more space, so the EBS root volume was increased to 30 GB in AWS.

After modifying the EBS volume, the disk showed 30 GB but the root partition was still approximately 6.9 GB. The partition and filesystem had to be expanded.

For this EC2 instance, the device name was `/dev/xvda` and the root partition was `/dev/xvda1`:

```bash
sudo apt-get update
sudo apt-get install -y cloud-guest-utils
sudo growpart /dev/xvda 1
sudo resize2fs /dev/xvda1
```

Verify the result:

```bash
df -h /
lsblk
```

The root filesystem should then show approximately 28-30 GB.

> Device names can differ between EC2 instances. Use `lsblk` first. This instance used `/dev/xvda`, not `/dev/nvme0n1`.

## 2. Start Minikube

Start Minikube with the Docker driver:

```bash
minikube start --driver=docker --cpus=2 --memory=3072
```

Verify the cluster:

```bash
minikube status
kubectl get nodes
```

Expected node status:

```text
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   ...   ...
```

## 3. Create a Deployment

Create a file named `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
```

Apply the manifest:

```bash
kubectl apply -f deployment.yaml
```

## 4. Watch Pods Being Created

Watch the Pods in one terminal:

```bash
kubectl get pods --watch
```

Or watch the Deployment, ReplicaSet, and Pods together:

```bash
kubectl get deploy,rs,pods --watch
```

The Pods normally move through states such as:

```text
Pending -> ContainerCreating -> Running
```

Press `Ctrl+C` to stop watching.

Check the final state:

```bash
kubectl get deployment
kubectl get replicaset
kubectl get pods -o wide
```

Expected result:

```text
NAME               READY   UP-TO-DATE   AVAILABLE
nginx-deployment   3/3     3            3
```

## 5. Understand the Resource Relationship

The resource relationship is:

```text
Deployment -> ReplicaSet -> Pods
```

The Deployment creates and manages a ReplicaSet. The ReplicaSet creates and manages the Pods.

Find the ReplicaSet created by the Deployment:

```bash
kubectl describe deployment nginx-deployment
```

Look for the `NewReplicaSet` field.

Get the ReplicaSet name automatically:

```bash
RS_NAME=$(kubectl get rs -l app=nginx -o jsonpath='{.items[0].metadata.name}')
echo "$RS_NAME"
```

Inspect the ReplicaSet:

```bash
kubectl describe replicaset "$RS_NAME"
```

Show each Pod and its owner:

```bash
kubectl get pods \
  -o custom-columns='POD:.metadata.name,OWNER:.metadata.ownerReferences[0].name'
```

The output should show that every Pod is owned by the ReplicaSet:

```text
POD                              OWNER
nginx-deployment-xxxxx-abcde     nginx-deployment-xxxxx
nginx-deployment-xxxxx-fghij     nginx-deployment-xxxxx
nginx-deployment-xxxxx-klmno     nginx-deployment-xxxxx
```

### Conclusion

A Deployment does not create Pods directly. It creates and manages a ReplicaSet, and the ReplicaSet creates and manages the Pods. Pod `ownerReferences` provide direct evidence of this relationship.

## 6. Scale the Deployment

Scale from three Pods to five:

```bash
kubectl scale deployment nginx-deployment --replicas=5
kubectl get deploy,rs,pods --watch
```

The existing ReplicaSet should create two additional Pods.

## 7. Open a Shell Inside a Pod

List the Pods:

```bash
kubectl get pods
```

Open a shell in one NGINX Pod:

```bash
kubectl exec -it <pod-name> -- /bin/sh
```

For example:

```bash
kubectl exec -it nginx-deployment-abc123-xyz45 -- /bin/sh
```

NGINX commonly provides `/bin/sh`, but not `/bin/bash`.

Run commands inside the container:

```bash
hostname
pwd
ls
```

Exit the container shell:

```bash
exit
```

`kubectl exec` is the normal Kubernetes method for entering a container. A Pod IP is usually internal and Pods normally do not run an SSH server.

## 8. Clean Up Kubernetes Resources

Delete the Deployment. Its ReplicaSet and Pods will be removed as part of the cleanup:

```bash
kubectl delete deployment nginx-deployment
```

Verify:

```bash
kubectl get pods
kubectl get deployment
kubectl get replicaset
```

Delete the local manifest file if it is no longer needed:

```bash
rm -f deployment.yaml
```

Delete the Minikube cluster:

```bash
minikube delete --all --purge
```

## 9. Clean Up Docker and Ubuntu Packages

Check Docker disk usage:

```bash
sudo docker system df
```

Remove unused Docker images, containers, and networks:

```bash
sudo docker system prune -af
```

To remove unused Docker volumes as well, only when they are no longer needed:

```bash
sudo docker system prune -af --volumes
```

Clean unused Ubuntu packages and package cache:

```bash
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean
```

Reduce old system logs:

```bash
sudo journalctl --vacuum-time=3d
```

Check the final disk usage:

```bash
df -h /
```

## Key Learnings

1. An EC2 EBS volume, partition, and filesystem are separate layers. After increasing an EBS volume, the partition and filesystem may also need to be expanded.
2. `tmpfs` entries shown by `df -h` are RAM-backed temporary filesystems, not EBS storage.
3. Minikube with the Docker driver stores its images and containers in Docker storage.
4. A Deployment manages a ReplicaSet.
5. A ReplicaSet creates and manages Pods.
6. `kubectl get ... --watch` or `kubectl get ... -w` displays resource changes in real time.
7. `kubectl exec` is normally used to enter a Pod instead of SSH.
8. Always inspect resources before using Docker cleanup commands, especially commands that remove volumes.
