# Kubernetes Architecture

## 1. Overview

Kubernetes follows a **cluster-based architecture**.

A Kubernetes cluster is broadly divided into two parts:

1. **Control Plane** — manages and controls the cluster
2. **Data Plane (Worker Nodes)** — runs the application workloads

```text
                  Kubernetes Cluster
                         │
             ┌───────────┴───────────┐
             │                       │
        Control Plane             Data Plane
        (Management)             (Workloads)
             │                       │
     ┌───────┼────────┐       ┌──────┼──────┐
     │       │        │       │      │      │
   API    Scheduler  etcd   Node 1  Node 2  Node 3
   Server
     │
 Controller
  Manager
     │
   CCM
```

The **Control Plane decides and manages what should happen**, while the **Data Plane runs the actual application workloads**.

---

# 2. Control Plane

The Control Plane is the **management/decision-making layer** of Kubernetes.

Its major components are:

* API Server
* Scheduler
* etcd
* Controller Manager
* Cloud Controller Manager (CCM)

---

# 3. API Server

The **kube-apiserver** is the main communication interface for the Kubernetes cluster.

It acts as the central entry point for requests to the Kubernetes API.

For example, when you run:

```bash
kubectl create deployment nginx --image=nginx
```

the request goes through the API Server.

A simplified flow is:

```text
kubectl
   │
   ↓
API Server
   │
   ├── etcd
   ├── Scheduler
   └── Controllers
```

Other components and applications can also communicate with Kubernetes through the API Server.

### Main responsibilities

* Authenticate and authorize API requests
* Validate requests
* Expose the Kubernetes API
* Read/write cluster state
* Coordinate communication between Kubernetes components

> **Remember:** API Server = the main gateway to the Kubernetes cluster.

---

# 4. etcd

**etcd** is a distributed key-value store used by Kubernetes to persist cluster state.

It stores important information about the Kubernetes cluster, such as:

* Nodes
* Pods
* Deployments
* Services
* ConfigMaps
* Secrets
* Cluster configuration
* Desired state of Kubernetes resources

Conceptually:

```text
             Kubernetes API Server
                     │
                     ↓
                    etcd
                     │
              Key → Value
```

For example, Kubernetes may maintain information representing:

```text
Pod → desired configuration/state
Deployment → replica configuration
Service → service configuration
```

### Why is etcd important?

Kubernetes needs a reliable place to persist the state of the cluster.

If the control plane needs to know what resources exist and what their desired configuration is, etcd provides that persistent backing store.

> **Remember:** etcd = Kubernetes cluster state store.

---

# 5. Scheduler

The **kube-scheduler** decides which worker node should run a newly created Pod.

For example:

```text
New Pod
   │
   ↓
API Server
   │
   ↓
Scheduler
   │
   ├── Node 1
   ├── Node 2
   └── Node 3
          ↓
    Selects suitable node
```

The scheduler considers factors such as:

* Available CPU
* Available memory
* Node constraints
* Affinity/anti-affinity
* Taints and tolerations
* Other scheduling rules

### Important correction

The scheduler **does not actually create or start the container**.

It primarily makes the **scheduling decision**: which node should run the Pod.

After the Pod is assigned to a node, the kubelet on that node works with the container runtime to make the Pod actually run.

---

# 6. Controller Manager

The **kube-controller-manager** runs several Kubernetes controllers.

Controllers continuously compare:

```text
Desired State
     vs
Actual State
```

If they are different, controllers take corrective action.

```text
Desired State
      │
      ↓
Controller
      │
      ↓
Actual State
      │
      ↓
Corrective Action
```

Examples include:

* Node Controller
* ReplicaSet Controller
* Deployment Controller
* Job Controller
* Namespace Controller
* Endpoint-related controllers

---

## 6.1 Node Controller

The Node Controller monitors the health/status of nodes.

For example:

```text
Node 1 → Healthy
Node 2 → Healthy
Node 3 → Not responding
```

The controller detects changes in node status and performs the appropriate control-plane actions.

---

## 6.2 ReplicaSet Controller

The ReplicaSet Controller maintains the desired number of Pod replicas.

Suppose:

```text
Desired replicas = 3
```

Current state:

```text
Pod 1 → Running
Pod 2 → Running
Pod 3 → Failed
```

The controller detects:

```text
Desired = 3
Actual  = 2
```

and works toward restoring:

```text
Pod 1 → Running
Pod 2 → Running
Pod 3 → Running
```

This is an important part of Kubernetes **self-healing**.

---

## 6.3 Deployment Controller

The Deployment Controller manages Deployments and their underlying ReplicaSets.

It supports mechanisms such as:

* Rolling updates
* Rollbacks
* Replica management

For example:

```text
Deployment
     │
     ↓
ReplicaSet
     │
     ↓
Pods
```

---

# 7. Cloud Controller Manager (CCM)

The **Cloud Controller Manager** allows Kubernetes to integrate with cloud-provider-specific functionality.

For example:

```text
Kubernetes
     │
     ↓
Cloud Controller Manager
     │
     ├── AWS
     ├── Azure
     └── Google Cloud
```

It separates cloud-specific logic from the core Kubernetes components.

Depending on the cloud provider and configuration, cloud integration can include functionality related to:

* Nodes
* Load balancers
* Cloud networking
* Cloud storage

> **Remember:** CCM = bridge between Kubernetes and cloud-provider-specific functionality.

---

# 8. Data Plane / Worker Nodes

The **Data Plane** contains the worker nodes that run application workloads.

A worker node typically contains:

* kubelet
* kube-proxy
* Container Runtime

And it runs Pods.

```text
Worker Node
┌─────────────────────────────┐
│          kubelet            │
│          kube-proxy         │
│      Container Runtime      │
│                             │
│   Pod 1       Pod 2         │
│ ┌───────┐   ┌───────┐      │
│ │ App   │   │ App   │      │
│ │Container  │Container     │
│ └───────┘   └───────┘      │
└─────────────────────────────┘
```

---

# 9. kubelet

The **kubelet** is the primary node-level agent.

It runs on **each worker node**.

Its responsibility is to make sure that the Pods assigned to its node are running according to their specifications.

For example:

```text
Control Plane
      │
      │ Pod specification
      ↓
API Server
      │
      ↓
kubelet on Worker Node
      │
      ↓
Container Runtime
      │
      ↓
Containers
```

The kubelet:

* Receives Pod specifications through the Kubernetes API
* Works with the container runtime
* Starts and stops containers as required
* Monitors the containers in its Pods
* Reports node and Pod status back to the API Server

### Important point

The kubelet is **not the scheduler**.

The scheduler decides:

> "This Pod should run on Node 2."

The kubelet on Node 2 then works to ensure that the Pod actually runs there.

> **Remember:** kubelet = node-level agent responsible for running and monitoring Pods assigned to its node.

---

# 10. Container Runtime

The **container runtime** is the software responsible for actually running containers.

It handles tasks such as:

* Pulling container images
* Creating containers
* Starting containers
* Stopping containers
* Managing the container lifecycle

Common container runtimes include:

* containerd
* CRI-O

Modern Kubernetes uses the **Container Runtime Interface (CRI)** to communicate with supported container runtimes.

Simplified flow:

```text
kubelet
   │
   ↓
CRI
   │
   ↓
Container Runtime
   │
   ↓
Container
```

> **Remember:** Container runtime = actually runs the containers.

---

# 11. kube-proxy

**kube-proxy** is a node-level networking component associated with Kubernetes Services.

It helps implement the networking rules needed to direct traffic to the appropriate backend Pods.

For example:

```text
Client
  │
  ↓
Kubernetes Service
  │
  ↓
kube-proxy networking rules
  │
  ├────→ Pod 1
  ├────→ Pod 2
  └────→ Pod 3
```

This allows traffic sent to a Service to reach the appropriate backend Pods.

### Load balancing

When a Service has multiple backend Pods, traffic can be distributed among those endpoints according to the networking implementation.

> **Important correction:** kube-proxy is not itself the Kubernetes scheduler or a general-purpose load balancer. Its main role is implementing Service networking on nodes.

Also, **Docker's `docker0` bridge and Kubernetes' kube-proxy are not equivalent components**. `docker0` is a Docker networking bridge, while kube-proxy implements Kubernetes Service networking rules.

---

# 12. Complete Kubernetes Architecture

Putting everything together:

```text
                         Kubernetes Cluster
                                │
              ┌─────────────────┴─────────────────┐
              │                                   │
        CONTROL PLANE                         DATA PLANE
        Management Layer                      Worker Nodes
              │                                   │
     ┌────────┼─────────┐               ┌─────────┼─────────┐
     │        │         │               │         │         │
 API Server Scheduler  etcd          Worker 1  Worker 2  Worker 3
     │                  │                 │         │         │
     │           Cluster State         kubelet   kubelet   kubelet
     │                                   │         │         │
     │                               kube-proxy kube-proxy kube-proxy
     │                                   │         │         │
     │                              Runtime    Runtime    Runtime
     │                                   │         │         │
     │                                  Pods      Pods      Pods
     │
 Controller Manager
     │
     ├── Node Controller
     ├── ReplicaSet Controller
     ├── Deployment Controller
     └── Other Controllers
     
 Cloud Controller Manager
```

---

# 13. End-to-End Example

Suppose you run:

```bash
kubectl create deployment nginx --image=nginx
```

A simplified sequence is:

```text
1. kubectl
      ↓
2. API Server
      ↓
3. API Server records the desired state
      ↓
4. Deployment Controller works with the Deployment
      ↓
5. ReplicaSet is created/managed
      ↓
6. A Pod is created
      ↓
7. Scheduler selects a suitable worker node
      ↓
8. kubelet on that node sees the Pod specification
      ↓
9. kubelet instructs the container runtime
      ↓
10. Runtime pulls the nginx image if necessary
      ↓
11. Container starts
      ↓
12. kubelet monitors the Pod
      ↓
13. Status is reported back through the API Server
```

The cluster state is persisted in **etcd**.

---

# 14. Key Mental Model

The easiest way to remember the architecture is:

### Control Plane

> **"What should happen?"**

* API Server → communication gateway
* Scheduler → chooses the node
* Controller Manager → maintains desired state
* etcd → stores cluster state
* CCM → cloud-provider integration

### Data Plane

> **"Actually run the application."**

* kubelet → manages Pods on the node
* Container Runtime → runs containers
* kube-proxy → implements Service networking
* Pods → run the application workload

---

# 15. Interview Revision

| Component                 | Simple meaning                               |
| ------------------------- | -------------------------------------------- |
| **API Server**            | Main gateway/API of Kubernetes               |
| **etcd**                  | Persistent key-value store for cluster state |
| **Scheduler**             | Decides which node should run a Pod          |
| **Controller Manager**    | Maintains desired state                      |
| **Node Controller**       | Monitors nodes                               |
| **ReplicaSet Controller** | Maintains desired Pod replicas               |
| **Deployment Controller** | Manages Deployments and ReplicaSets          |
| **CCM**                   | Cloud-provider integration                   |
| **kubelet**               | Manages Pods on a worker node                |
| **Container Runtime**     | Actually runs containers                     |
| **kube-proxy**            | Implements Kubernetes Service networking     |

## One-line architecture

> **API Server receives requests → etcd stores state → controllers maintain desired state → scheduler selects nodes → kubelet manages Pods → container runtime runs containers → kube-proxy handles Service networking.**
