# Configuration Management & Ansible

## 1. What is Configuration Management?

Configuration Management (CM) is the practice of automatically maintaining the desired software, system, and infrastructure configuration across multiple servers.

Instead of manually configuring every server, configuration-management tools allow engineers to define the desired configuration once and apply it consistently across many servers.

### Example

```text
AWS Region
├── Availability Zone A
│   ├── Server 1
│   └── Server 2
└── Availability Zone B
    ├── Server 3
    └── Server 4
```

Suppose all servers need:

- Nginx installed
- Port 80 enabled
- A specific configuration file
- A specific application version
- A specific user

Configuration Management automates these tasks and keeps the servers consistent.

---

## 2. Popular Configuration Management Tools

| Tool | Architecture | Agent | Main Language / Format |
|---|---|---|---|
| Puppet | Master-Agent / Pull | Usually required | Puppet DSL |
| Chef | Server-Client / Pull | Required | Ruby-based DSL |
| SaltStack | Master-Minions / Push/Pull | Usually minion | YAML + Jinja |
| Ansible | Controller-Nodes / Push | **Agentless** | YAML |

---

## 3. Why Ansible is Popular

Ansible stands out because of:

1. **Agentless architecture** – no Ansible agent needs to be installed on managed Linux servers.
2. **Simple YAML playbooks** – automation is relatively easy to read and maintain.
3. **Cross-platform support** – can manage Linux, Windows, network devices, cloud resources, and more.
4. **Large module ecosystem** – modules are available for AWS, Azure, Docker, Kubernetes, databases, networking, etc.
5. **Ansible Galaxy** – provides reusable community roles and content.
6. **Dynamic inventory** – useful for automatically discovering changing cloud infrastructure.
7. **Idempotency** – tasks can be written to achieve a desired state without unnecessarily changing systems that are already correct.
8. **Easy integration** – works well with CI/CD tools such as GitHub Actions and Jenkins.

> Note: YAML is a data-serialization/configuration format, not a programming language.

---

# 4. Ansible Architecture

Ansible uses a **controller-based, agentless architecture**.

```text
                    Ansible Controller
                           |
             +-------------+-------------+
             |             |             |
             v             v             v
          Server 1      Server 2      Server 3
```

The controller connects to target systems and executes the required tasks.

### Linux

Ansible commonly uses:

```text
Ansible Controller
       |
      SSH
       |
Linux Server
```

### Windows

Ansible commonly uses:

```text
Ansible Controller
       |
   WinRM / PSRP
       |
Windows Server
```

---

# 5. Push Model vs Pull Model

## Ansible – Push Model

```text
Ansible Controller
       |
       +-----> Server 1
       |
       +-----> Server 2
       |
       +-----> Server 3
```

The controller initiates the connection and pushes tasks to the managed nodes.

## Puppet – Pull-oriented Model

```text
             Puppet Master
                  |
        Configuration available
                  |
       +----------+----------+
       |          |          |
       v          v          v
    Agent 1    Agent 2    Agent 3
       |          |          |
      Pull       Pull       Pull
```

Puppet agents commonly retrieve their configuration from the Puppet server.

---

# 6. Ansible Inventory

The **inventory** tells Ansible which systems it should manage.

Example:

```ini
[webservers]
10.0.1.10
10.0.1.11

[appservers]
10.0.2.10
10.0.2.11
```

The inventory can contain:

- IP addresses
- Hostnames
- Groups
- Variables
- Connection information

The basic flow is:

```text
Inventory
   |
   | Which servers?
   v
Ansible Controller
   |
   | SSH / WinRM
   v
Target Servers
```

---

# 7. Static Inventory

In a static inventory, the engineer manually maintains the server list.

```ini
[webservers]
10.0.1.10
10.0.1.11
10.0.1.12
```

This works well for small and relatively stable environments.

However, cloud infrastructure can change frequently.

---

# 8. Dynamic Inventory

Dynamic inventory allows Ansible to obtain information about infrastructure dynamically instead of manually maintaining every server.

For example, in AWS:

```text
AWS
 |
 +-- Region
 |
 +-- Availability Zones
 |
 +-- EC2 Instances
 |
 +-- Tags
 |
 v
Dynamic Inventory
 |
 v
Ansible
```

EC2 instances can be organized using tags such as:

```text
Environment = Production
Role = Web
```

Ansible can then discover relevant instances and manage them.

### Why Dynamic Inventory is Useful

Suppose Auto Scaling creates new instances:

```text
Before:
Web-1
Web-2

After scaling:
Web-1
Web-2
Web-3
Web-4
Web-5
```

With dynamic inventory, newly created instances can be discovered based on the configured inventory rules instead of manually adding every IP address.

---

# 9. Inventory + Playbook

Remember:

> **Inventory = WHERE to run**

> **Playbook = WHAT to do**

Example inventory:

```ini
[webservers]
10.0.1.10
10.0.1.11
```

Example playbook:

```yaml
- name: Configure web servers
  hosts: webservers
  become: yes

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
```

Execution:

```bash
ansible-playbook webserver.yml
```

---

# 10. How Ansible Connects to an AWS EC2 Server

A typical Linux workflow is:

```text
1. Launch EC2
       |
2. Configure Security Group
       |
3. Obtain private/public connectivity
       |
4. Configure SSH authentication
       |
5. Test SSH
       |
6. Add server to inventory
       |
7. Test Ansible connectivity
       |
8. Run playbook
```

## Step 1 – Launch EC2

Launch an Ubuntu/Linux EC2 instance.

## Step 2 – Network Access

Ensure the controller can reach the EC2 instance.

For SSH, TCP port **22** must be allowed from the appropriate trusted source.

Avoid opening SSH to the entire internet unless there is a specific reason.

## Step 3 – Authentication

For Linux, Ansible commonly uses:

```text
SSH
+
Private Key
+
Linux Username
```

First test normal SSH:

```bash
ssh -i my-key.pem ubuntu@SERVER_IP
```

If SSH doesn't work, fix the connectivity/authentication problem before troubleshooting Ansible.

## Step 4 – Add Server to Inventory

```ini
[webservers]
10.0.1.10
```

## Step 5 – Test Ansible

```bash
ansible webservers -m ping
```

A successful response looks similar to:

```text
10.0.1.10 | SUCCESS
```

The Ansible `ping` module is an Ansible connectivity/execution test; it is not the same as an ICMP network ping.

## Step 6 – Run a Playbook

```bash
ansible-playbook webserver.yml
```

Ansible connects to the servers and applies the defined tasks.

---

# 11. Ansible Across Availability Zones

Example:

```text
AWS Region
|
+-- AZ-A
|    +-- Web-1
|    +-- Web-2
|
+-- AZ-B
     +-- Web-3
     +-- Web-4
```

Ansible can manage all of these servers from the controller.

```text
                 Ansible Controller
                  /       |                        /        |                      Web-1     Web-2     Web-3/Web-4
```

The important requirement is **network connectivity and authentication** between the controller and target systems.

The controller could be inside AWS, on-premises, or in another reachable environment depending on the architecture.

---

# 12. Idempotency

Idempotency means that repeatedly applying the same configuration should not create unnecessary changes when the desired state has already been achieved.

Example:

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
```

First run:

```text
Nginx not installed
        |
        v
    Install Nginx
```

Second run:

```text
Nginx already installed
        |
        v
   No unnecessary change
```

This is an important property of configuration-management automation.

---

# 13. Ansible Modules

Ansible modules perform specific tasks.

Examples include modules for:

- Package installation
- File management
- Services
- Users
- AWS resources
- Docker
- Kubernetes
- Networking

Example:

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
```

You can also develop custom Ansible modules, including Python-based modules.

---

# 14. Ansible Galaxy

**Ansible Galaxy** is a community platform/ecosystem for sharing and reusing Ansible roles and content.

Instead of building every automation component from scratch, engineers can reuse existing roles where appropriate.

---

# 15. Advantages of Ansible

### Agentless

No continuously running Ansible agent is required on managed Linux hosts.

### Easy to Read

YAML playbooks are human-readable.

### Cross-Platform

Supports Linux, Windows, network devices, and cloud environments.

### Cloud Friendly

Dynamic inventory and cloud modules make Ansible useful for AWS/Azure environments.

### Reusable

Roles, modules, and Ansible Galaxy content can be reused.

### Automation

Useful for:

- Server configuration
- Software installation
- Application deployment
- User management
- Configuration changes
- Cloud automation

---

# 16. Drawbacks of Ansible

1. **Large-scale performance** – managing very large numbers of hosts can introduce execution overhead; configuration such as forks and asynchronous execution can help.
2. **Windows workflows** – Windows is supported, but Ansible's traditional ecosystem and workflows have been stronger around Linux/Unix.
3. **Debugging** – failures can involve playbooks, modules, authentication, network connectivity, or the target server.
4. **YAML syntax** – indentation and formatting errors can cause playbook failures.
5. **Network dependency** – Ansible needs connectivity to the managed system to execute remote tasks.

---

# 17. Best Practices

### Use SSH keys instead of passwords where appropriate

```text
Ansible Controller
       |
    SSH Key
       |
    Linux EC2
```

### Use least-privilege network access

Don't unnecessarily expose SSH/WinRM to the entire internet.

### Organize inventory into groups

```ini
[webservers]
...

[appservers]
...

[dbservers]
...
```

### Use variables

Avoid hardcoding values throughout playbooks.

### Use roles for larger projects

Roles make automation easier to organize and reuse.

### Use dynamic inventory in cloud environments

Especially useful when servers are created and destroyed dynamically.

### Store Ansible code in Git

Keep:

```text
Inventory
Playbooks
Roles
Variables
Documentation
```

under version control.

---

# 18. DevOps Project Structure

A clean GitHub repository could look like:

```text
ansible-configuration-management/
│
├── README.md
│
├── inventory/
│   ├── hosts.ini
│   └── aws_ec2.yml
│
├── playbooks/
│   ├── webserver.yml
│   └── users.yml
│
├── roles/
│   └── nginx/
│       ├── tasks/
│       ├── handlers/
│       ├── templates/
│       └── defaults/
│
├── group_vars/
│
└── docs/
    └── configuration-management.md
```

**Important:** Never upload private SSH keys such as `.pem` files, passwords, API keys, AWS access keys, or other secrets to GitHub.

Add them to `.gitignore`.

Example:

```gitignore
*.pem
.env
*.key
```

---

# 19. Practical Learning Project

A good hands-on project is:

```text
GitHub
   |
   v
Ansible Repository
   |
   v
AWS EC2
   |
   +-- Web Server 1
   +-- Web Server 2
   +-- Web Server 3
          |
          v
Ansible
          |
          +-- Install Nginx
          +-- Create Users
          +-- Configure Firewall
          +-- Deploy Configuration
          +-- Start Services
```

Then extend it with:

```text
Dynamic Inventory
        ↓
AWS EC2
        ↓
Ansible
        ↓
Nginx Configuration
        ↓
GitHub Actions
        ↓
Automated Deployment
```

This gives you practical experience with **Linux + AWS + Ansible + GitHub + CI/CD**, which is much more valuable for a DevOps portfolio than only studying Ansible theory.

