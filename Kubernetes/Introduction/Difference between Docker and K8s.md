# Introduction to Kubernetes

## 1. Why Do We Need Kubernetes?

Docker is a **containerization platform**. It helps us build an application as an image and run that image as a container.

Docker works well for development and small workloads, but managing many containers manually across multiple servers becomes difficult in a production environment. Kubernetes solves this problem by orchestrating containerized workloads across a cluster.

> **Simple understanding:** Docker creates and runs containers. Kubernetes manages containerized applications reliably across multiple nodes.

---

## 2. Limitations of Using Docker Alone

### 2.1 Single-host dependency

When containers run on only one Docker host, they depend on that host's operating system and kernel. If the host or kernel fails, multiple containers running on that host can become unavailable.

> One container failure does not normally crash other containers. The major risk is a shared host failure or a container consuming poorly controlled shared resources.

### 2.2 No built-in workload rescheduling across hosts

A Docker container can be configured with a restart policy, but standalone Docker does not provide cluster-level scheduling. If the complete host fails, Docker alone cannot move the workload automatically to another healthy server.

### 2.3 No built-in application autoscaling

With standalone Docker, replicas usually need to be created and managed manually. It does not automatically increase or decrease the number of application instances based on CPU, memory, or other workload metrics.

### 2.4 Difficult to manage at production scale

Production environments may require:

- Multiple application replicas
- Multiple servers
- Self-healing
- Automatic scaling
- Service discovery
- Load balancing
- Rolling updates and rollbacks
- Centralized configuration and secret management

Managing these requirements using individual `docker run` commands becomes complex and error-prone.

---

## 3. What Is Kubernetes?

Kubernetes, also called **K8s**, is an open-source container orchestration platform. It manages the deployment, scaling, networking, and availability of containerized applications.

A Kubernetes environment is organized as a **cluster**, which contains:

- **Control Plane:** Manages the cluster and makes scheduling decisions.
- **Worker Nodes:** Run application workloads.
- **Pods:** The smallest deployable units in Kubernetes. A Pod contains one or more containers.

```text
Kubernetes Cluster
|
|-- Control Plane
|   |-- API Server
|   |-- Scheduler
|   `-- Controller Manager
|
|-- Worker Node 1
|   |-- Pod A
|   `-- Pod B
|
`-- Worker Node 2
    |-- Pod C
    `-- Pod D
```

---

## 4. Advantages of Kubernetes

### 4.1 Multi-node cluster

Kubernetes can distribute application Pods across multiple worker nodes. This avoids depending entirely on a single host and improves application availability.

However, a cluster does not guarantee that every Pod is automatically isolated from every other Pod. Proper resource requests, limits, security controls, and workload design are still required.

### 4.2 Self-healing

Kubernetes continuously compares the **desired state** with the **actual state**.

For example, if a Deployment requires three replicas and one Pod fails:

1. Kubernetes detects that only two replicas are running.
2. The Deployment's ReplicaSet maintains the desired replica count.
3. The scheduler selects a suitable node for the replacement Pod.
4. Kubernetes creates a new Pod.

The kubelet can also restart a failed container according to the Pod's restart policy. Liveness probes can help Kubernetes detect an unhealthy container.

```text
Desired state: 3 Pods
Actual state:  2 Pods
        |
        v
ReplicaSet detects the difference
        |
        v
Scheduler selects a suitable node
        |
        v
A replacement Pod is created
```

> Kubernetes can restart or replace failed workloads, but it does not automatically fix defects in application code.

### 4.3 Autoscaling

Kubernetes supports different types of scaling:

- **Horizontal Pod Autoscaler (HPA):** Changes the number of Pod replicas based on configured metrics such as CPU, memory, or custom metrics.
- **Vertical Pod Autoscaler (VPA):** Recommends or adjusts CPU and memory resources for Pods, depending on its configured mode.
- **Node or cluster autoscaling:** Adds or removes worker-node capacity when supported and configured in the environment.

> **Important correction:** A ReplicaSet provides self-healing by maintaining a desired replica count. HPA is the Kubernetes component commonly used for automatic horizontal scaling.

### 4.4 High availability and failover

When a worker node becomes unavailable, controller-managed workloads can be recreated on another healthy node if sufficient capacity and required resources are available.

This reduces the impact of server failure, but high availability still depends on correct cluster architecture, application design, storage, networking, and capacity.

### 4.5 Declarative configuration

In Kubernetes, we describe the desired state in YAML manifests. Kubernetes controllers continuously work to maintain that state.

Example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  replicas: 3
```

This tells Kubernetes that the application should have three replicas.

---

## 5. Docker vs Kubernetes

| Feature | Standalone Docker | Kubernetes |
|---|---|---|
| Primary purpose | Build and run containers | Orchestrate containerized workloads |
| Typical infrastructure | Commonly managed on one host at a time | Cluster containing control plane and worker nodes |
| Container restart | Supports restart policies on the same host | Restarts containers and replaces controller-managed Pods |
| Host failure recovery | No built-in cross-host rescheduling | Can reschedule eligible workloads to healthy nodes |
| Autoscaling | Not built into standalone Docker | Supports HPA, VPA, and node autoscaling when configured |
| Desired replica management | Usually manual | ReplicaSet maintains the declared replica count |
| Service discovery | Requires additional setup | Built-in Services and cluster DNS |
| Rolling updates | Manual for standalone containers | Supported through Deployments |
| Production-scale management | Becomes difficult as workload size grows | Designed for managing distributed container workloads |

---

## 6. Important Corrections and Clarifications

1. **Containers are ephemeral, not Docker itself.** Container writable data can disappear when a container is removed unless persistent storage is used.
2. **One failed container does not normally bring down every container.** A host or kernel failure can affect all containers on that host.
3. **ReplicaSet is not an autoscaler.** It maintains a fixed desired number of replicas.
4. **HPA performs horizontal autoscaling.** It changes replica count based on configured metrics.
5. **ReplicationController is an older workload controller.** ReplicaSet and Deployment are generally used for modern applications.
6. **Kubernetes self-healing has limits.** It can restart or replace workloads, but application bugs and unavailable dependencies still require investigation.
7. **Docker and Kubernetes are not direct replacements.** Docker helps create and run containers, while Kubernetes orchestrates containers through a compatible container runtime.

---

## 7. Interview-Ready Answer

**Why do we need Kubernetes when Docker already exists?**

Docker helps us package and run applications as containers. However, standalone Docker does not provide full cluster-level orchestration for production workloads. Kubernetes manages containers across multiple nodes and provides self-healing, autoscaling, scheduling, service discovery, load balancing, rolling updates, and declarative configuration. Therefore, Docker solves containerization, while Kubernetes solves container orchestration at scale.

---

## 8. Quick Revision

- Docker packages and runs containers.
- Kubernetes manages containerized applications across a cluster.
- A Pod is the smallest deployable unit in Kubernetes.
- A ReplicaSet maintains the desired number of Pods.
- The scheduler selects a suitable node for a new Pod.
- The kubelet helps ensure containers are running on a node.
- HPA automatically changes Pod replica count based on configured metrics.
- Kubernetes supports self-healing, but it cannot fix application-code defects automatically.

---

## References

- [Kubernetes Self-Healing](https://kubernetes.io/docs/concepts/architecture/self-healing/)
- [Kubernetes Horizontal Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/)
