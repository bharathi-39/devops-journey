# Kubernetes Services

## 1. What Is a Kubernetes Service?

A **Kubernetes Service** is a networking abstraction that provides a stable way to access one or more Pods.

Pods are ephemeral. A Deployment can create, terminate, and replace Pods to maintain the desired number of replicas. Each replacement Pod can receive a new IP address. Clients therefore should not depend directly on individual Pod IP addresses.

A Service solves this problem by providing a stable endpoint in front of a changing group of Pods.

```text
Client
  |
  v
Service: stable IP and DNS name
  |
  +----> Pod 1
  +----> Pod 2
  `----> Pod 3
```

---

## 2. What Happens Without a Service?

Consider a Deployment with three replicas:

```text
Pod 1: 10.244.1.10
Pod 2: 10.244.1.11
Pod 3: 10.244.2.15
```

If a client connects directly to `10.244.1.11` and Pod 2 is terminated, the ReplicaSet can create a replacement Pod:

```text
Old Pod 2: 10.244.1.11  -> terminated
New Pod 4: 10.244.2.20  -> created
```

The client still knows only the old IP address and cannot automatically discover the replacement. Direct Pod-IP tracking therefore becomes unreliable.

With a Service, the client connects to the Service endpoint instead of an individual Pod IP. Kubernetes updates the Service's backend endpoint information when matching Pods change.

---

## 3. How Does a Service Find Pods?

A Service commonly uses **label selectors** to identify its backend Pods.

### Labels on the Pods

```yaml
metadata:
  labels:
    app: python-app
```

### Matching selector on the Service

```yaml
spec:
  selector:
    app: python-app
```

The key and value must match:

```text
Pod label:        app=python-app
Service selector: app=python-app
                         |
                         v
              Pod becomes a backend
```

If a Deployment creates a replacement Pod with the same label, that Pod can be included as a backend for the Service. EndpointSlice objects store information about the current network endpoints backing the Service.

> Labels and selectors identify the backend Pods. Service discovery itself is normally provided through the Service's stable DNS name and virtual IP.

---

## 4. Stable Endpoint and Service Discovery

A Service can provide:

- A stable virtual IP address
- A stable DNS name
- A logical endpoint for a changing set of Pods

Applications inside the cluster can normally connect using a Service name instead of tracking Pod IP addresses.

For example, a Service named `python-service` in the `default` namespace can be addressed within that namespace using:

```text
python-service
```

Its fully qualified internal DNS name is commonly:

```text
python-service.default.svc.cluster.local
```

This allows clients to discover the application by name even when the backing Pods are replaced.

---

## 5. Traffic Distribution

A Service provides one logical endpoint for multiple matching backend Pods. A Service proxy implementation on the nodes programs the data plane so traffic sent to the Service can be routed to its available backends.

In many Kubernetes environments, this role is implemented by **kube-proxy**. The exact packet-processing mechanism can vary by cluster implementation and configuration.

```text
Request
   |
   v
Service virtual endpoint
   |
   +----> Ready Pod A
   +----> Ready Pod B
   `----> Ready Pod C
```

A Service is not a Pod and does not physically sit on top of Pods. It is an API object and networking abstraction represented through the cluster's networking data plane.

---

## 6. Benefits of Kubernetes Services

### 6.1 Stable access

Clients use the stable Service endpoint rather than changing Pod IP addresses.

### 6.2 Service discovery

Cluster DNS allows workloads to discover Services using consistent names.

### 6.3 Traffic distribution

Traffic can be distributed across multiple healthy backend endpoints selected by the Service.

### 6.4 Loose coupling

A frontend does not need to know the IP addresses or names of individual backend Pods.

### 6.5 Application exposure

Different Service types provide internal cluster access or make an application reachable through node or external load-balancer endpoints.

---

## 7. Service Port Fields

A Service manifest commonly uses three port-related fields:

```yaml
ports:
  - port: 80
    targetPort: 8000
    nodePort: 30080
```

| Field | Meaning |
|---|---|
| `port` | Port exposed by the Service |
| `targetPort` | Port on the backend Pod or container to which traffic is forwarded |
| `nodePort` | Port opened on each node when the Service type is `NodePort` |

Traffic flow in this example:

```text
Client -> Service port 80 -> Pod targetPort 8000
```

For a NodePort Service:

```text
External client -> NodeIP:30080 -> Service -> Pod:8000
```

---

## 8. Types of Kubernetes Services

### 8.1 ClusterIP

`ClusterIP` is the default Service type.

It exposes the Service on an internal cluster IP and is normally reachable only from within the Kubernetes cluster.

```text
Pod or workload inside cluster
             |
             v
       ClusterIP Service
             |
             v
       Backend Pods
```

Typical uses:

- Frontend-to-backend communication
- Application-to-database communication inside the cluster
- Internal microservices

> ClusterIP communication is not limited to Pods on the same node. It provides an internal Service endpoint across the cluster.

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-service
spec:
  type: ClusterIP
  selector:
    app: python-app
  ports:
    - port: 80
      targetPort: 8000
```

---

### 8.2 NodePort

`NodePort` exposes the Service on a port of each node. A client that can reach a node can access the application through:

```text
<NodeIP>:<NodePort>
```

Traffic flow:

```text
External client
      |
      v
NodeIP:NodePort
      |
      v
ClusterIP Service
      |
      v
Backend Pod
```

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-service
spec:
  type: NodePort
  selector:
    app: python-app
  ports:
    - port: 80
      targetPort: 8000
      nodePort: 30080
```

NodePort can be useful for learning, testing, and situations where direct node-level exposure is acceptable. Production suitability depends on the environment and architecture.

---

### 8.3 LoadBalancer

`LoadBalancer` requests an external load balancer from a supported cloud or infrastructure integration.

Traffic flow:

```text
External client
      |
      v
External load balancer
      |
      v
Kubernetes Service
      |
      v
Backend Pods
```

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-service
spec:
  type: LoadBalancer
  selector:
    app: python-app
  ports:
    - port: 80
      targetPort: 8000
```

The external load balancer and external address depend on the cluster environment and its provider integration. In a local cluster such as Minikube, the behavior differs from a managed cloud cluster.

---

## 9. ClusterIP vs NodePort vs LoadBalancer

| Service type | Reachability | Access pattern | Common purpose |
|---|---|---|---|
| `ClusterIP` | Inside the cluster | Service IP or DNS name | Internal application communication |
| `NodePort` | Through a reachable node | `NodeIP:NodePort` | Basic external or testing access |
| `LoadBalancer` | Through an external load balancer when supported | External IP or hostname | External application exposure |

Relationship:

```text
ClusterIP
   ↑
NodePort includes ClusterIP behavior
   ↑
LoadBalancer commonly builds on NodePort behavior
```

---

## 10. Important Corrections

1. The correct term is **Pod**, not port.
2. A Service does not sit physically on top of Pods. It is a Kubernetes API object and networking abstraction.
3. Labels and selectors connect a Service logically to its backend Pods.
4. Service discovery is provided through a stable Service IP and DNS name, not merely by labels.
5. ClusterIP is not limited to communication within one node. It is intended for access from within the cluster.
6. You do not have to log in to the target Pod to access a ClusterIP Service. Another Pod or suitable client inside the cluster can call it.
7. NodePort uses a port on each node and is accessed using `NodeIP:NodePort`.
8. LoadBalancer requires supported infrastructure or cloud integration to provision an external load balancer.
9. kube-proxy is commonly involved in implementing Service traffic routing, but the precise data-plane implementation can vary.
10. Services normally route to ready backend endpoints, but readiness must be configured correctly for the application.

---

## 11. Interview-Ready Answer

**Why do we need a Service in Kubernetes?**

Pods are ephemeral and their IP addresses can change when they are recreated. A Kubernetes Service provides a stable virtual IP and DNS name for a logical group of Pods. It commonly uses label selectors to identify the backend Pods and provides service discovery and traffic distribution. ClusterIP exposes an application inside the cluster, NodePort exposes it through a port on every node, and LoadBalancer requests an external load balancer from supported infrastructure.

---

## 12. Quick Revision

- Pod IP addresses are not reliable client endpoints.
- A Service provides a stable IP and DNS name.
- Labels and selectors associate a Service with Pods.
- EndpointSlices track the current Service backends.
- ClusterIP is internal to the cluster.
- NodePort exposes the Service through `NodeIP:NodePort`.
- LoadBalancer requests external exposure from supported infrastructure.
- `port` is the Service port.
- `targetPort` is the backend Pod port.
- `nodePort` is the node-level port used by NodePort.

---

## References

- [Kubernetes Service documentation](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Kubernetes networking documentation](https://kubernetes.io/docs/concepts/services-networking/)
- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
