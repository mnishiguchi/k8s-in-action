# [Chapter 3.1] Deploying a K8s cluster

## A: Using the built-in Kubernetes cluster in Docker Desktop

- MacOS Docker Desktop contains a single-node k8s cluster that you can enable via its Settings dialog box.

### Exploring the virtual machine from the inside

Docker Desktop provides no command to log into the VM. However, you can run a special container configured to use the VM’s namespaces to run a remote shell, which is virtually identical to using SSH to access a remote server.

```sh
# Create a container from the alpine image.
# Make the container use the host's namespaces instead of being sandboxed.
# Give the container unrestricted access to all sys-calls.
# Run the container interactive mode.
# Ensure the container is deleted when it terminates.
# Mount the host's root directory to the `/host` in the container.
# Make the `/host` the root directory in the container
docker run \
  --net=host \
  --ipc=host \
  --uts=host \
  --pid=host \
  --privileged \
  --security-opt=seccomp=unconfined \
  -it \
  --rm \
  -v /:/host \
  alpine \
  chroot /host
```

Try listing processes by executing the `ps aux` command or explore the network interfaces by running `ip addr`.

## B: Running a local cluster using [Minikube](https://github.com/kubernetes/minikube)

- The cluster consists of a single node and is suitable for both testing Kubernetes and developing applications locally.
- The author recommend this to K8s newbies.

### Installing minikube

- https://minikube.sigs.k8s.io/docs/start/macos/

```sh
brew install minikube

which minikube
```

### Starting a k8s cluster with minikube

```sh
minikube start

minikube status
# host: Running
# kubelet: Running
# apiserver: Running
# kubeconfig: Configured

minikube docker-env

minikube ssh
$ ps aux
```

## C: Running a local cluster using [kind (Kubernetes in Docker)](https://kind.sigs.k8s.io/docs/user/quick-start/)

- Instead of running Kubernetes in a virtual machine or directly on the host, kind runs each Kubernetes cluster node inside a container.
- Kind runs a single-node cluster by default.
- If you want to run a cluster with multiple worker nodes, you must first create a configuration file named `kind-multi-node.yaml` with the following content.
- The author prefers kind to minikube because when you run k8s using kind, all k8s components run in your host OS.

> ... This makes kind the perfect tool for development and testing, as everything runs locally and you can debug running processes as easily as when you run them outside of a container. I prefer to use this approach when I develop apps on Kubernetes, as it allows me to do magical things like run network traffic analysis tools such as Wireshark or even my web browser inside the containers that run my applications. ...

### Starting a k8s cluster with kind

```sh
# Default cluster context name is `kind`.
kind create cluster

# Another cluster with a custom context name.
kind create cluster --name kind-2

kind get clusters
# kind
# kind-2

kubectl cluster-info
# Kubernetes master is running at https://127.0.0.1:32769
# KubeDNS is running at https://127.0.0.1:32769/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

### Config

> By default, the cluster access configuration is stored in `${HOME}/.kube/config` if `$KUBECONFIG` environment variable is not set.

```sh
# Default config
cat ~/.kube/config

echo $KUBECONFIG
```

### Starting a multi-node cluster with kind

- First create a configuration file named `kind-multi-node.yaml` with the following content.

```sh
kind create cluster --config kind-multi-node.yaml

kind get nodes
# kind-control-plane
# kind-worker2
# kind-worker

docker ps
```

### Logging into cluster nodes provisioned by kind

- Instead of using Docker to run containers, nodes created by kind use the [CRI-O](https://cri-o.io/) container runtime, which I mentioned in the previous chapter as a lightweight alternative to Docker.

```sh
# Enter the node called `kind-control-plane`, which is equivalent to `minikube ssh`.
docker exec -it kind-control-plane bash

# Inside the `kind-control-plane` node, use `crictl` commands instead of `docker` .
root@kind-control-plane:/# crictl ps
```

### FAQ

- https://kind.sigs.k8s.io/docs/user/known-issues/
- https://github.com/kubernetes-sigs/kind/issues/575

## D: Creating a managed cluster with Google K8s Engine (GKE)

- https://cloud.google.com/kubernetes-engine/docs/quickstart
- Region us-east4: Ashburn, Northern Virginia, USA

### [`gcloud` command](https://cloud.google.com/sdk/gcloud/reference)

```sh
gcloud config list

gcloud projects list
```

### Create a two-node (per-region) cluster in GKE

- TIP: Each VM incurs costs. To reduce the cost of your cluster, you can reduce the number of nodes to one, or even to zero while not using it. See next section for details.

```sh
gcloud container clusters create kubia --num-nodes 2
# This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
# Creating cluster kubia in us-east4... Cluster is being health-checked (master is healthy)...done.
# Created [https://container.googleapis.com/v1/projects/mnishiguchi-k8s-in-action/zones/us-east4/clusters/kubia].
# To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-east4/kubia?project=mnishiguchi-k8s-in-action
# kubeconfig entry generated for kubia.
# NAME   LOCATION  MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION    NUM_NODES  STATUS
# kubia  us-east4  1.14.10-gke.27  35.186.174.163  n1-standard-1  1.14.10-gke.27  6          RUNNING

gcloud compute instances list
# NAME                                  ZONE        MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
# gke-kubia-default-pool-0a7f1562-bvpt  us-east4-a  n1-standard-1               10.150.0.7   35.245.55.154   RUNNING
# gke-kubia-default-pool-0a7f1562-hw19  us-east4-a  n1-standard-1               10.150.0.6   35.245.172.38   RUNNING
# gke-kubia-default-pool-75f9639e-fzxh  us-east4-b  n1-standard-1               10.150.0.5   35.221.60.131   RUNNING
# gke-kubia-default-pool-75f9639e-gmm5  us-east4-b  n1-standard-1               10.150.0.4   35.245.189.201  RUNNING
# gke-kubia-default-pool-04a1ed27-7z6d  us-east4-c  n1-standard-1               10.150.0.3   35.245.200.158  RUNNING
# gke-kubia-default-pool-04a1ed27-8m6g  us-east4-c  n1-standard-1               10.150.0.2   35.236.198.42   RUNNING

gcloud container clusters delete
# Deleting cluster kubia...done.

gcloud compute instances list
# Listed 0 items.
```

![](https://user-images.githubusercontent.com/7563926/78935081-10856d80-7a7a-11ea-823f-dd620b02d2d3.png)


### Scaling the number of notes

- You can even scale it down to zero so that your cluster doesn’t incur any costs.

```sh
gcloud container clusters resize kubia --size 0
```

### Inspecting a GKE worker node

```sh
gcloud compute ssh gke-kubia-default-pool-0a7f1562-bvpt
```

### FAQ

- [insufficient regional quota to satisfy request: resource “IN_USE_ADDRESSES”](https://stackoverflow.com/a/58629391/3837223)

```sh
gcloud compute project-info describe --project mnishiguchi-k8s-in-action | grep -C 2 IN_USE_ADDRESSES
gcloud compute regions describe us-east4  | grep -C 2 IN_USE_ADDRESSES
#   usage: 0.0
# - limit: 8.0
#   metric: IN_USE_ADDRESSES
#   usage: 6.0
# - limit: 500.0
```

## Creating a cluster using Amazon Elastic Kubernetes Service

### [`eksctl` command](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)

```sh
eksctl create cluster --name kubia --region eu-central-1 --nodes 2 --ssh-access
```
