# [Chapter 3.2] Interacting with k8s

- In order to interact with K8s, you use the `kubectl` CLI tool.

![](https://user-images.githubusercontent.com/7563926/79002882-6bbd6b80-7b1f-11ea-822e-1f41e8c5ad92.png)

## [`kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

- `kubectl` loads its configuration from a `kubeconfig` file.

```sh
export KUBECONFIG=/path/to/custom/kubeconfig
```

```sh
# Create a cluster in GKE
gcloud container clusters create kubia --num-nodes 1

gcloud compute instances list
# NAME                                  ZONE        MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
# gke-kubia-default-pool-fc207bf0-3zjb  us-east4-a  n1-standard-1               10.150.0.10  35.245.55.154  RUNNING
# gke-kubia-default-pool-ef8e6b97-2v19  us-east4-b  n1-standard-1               10.150.0.9   35.236.198.42  RUNNING
# gke-kubia-default-pool-271036ba-84s8  us-east4-c  n1-standard-1               10.150.0.8   35.221.60.131  RUNNING

# Verify the cluster is up
k cluster-info
# Kubernetes master is running at https://35.199.33.234
# GLBCDefaultBackend is running at https://35.199.33.234/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
# Heapster is running at https://35.199.33.234/api/v1/namespaces/kube-system/services/heapster/proxy
# KubeDNS is running at https://35.199.33.234/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
# Metrics-server is running at https://35.199.33.234/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

# List summary info of cluster nodes
k get nodes
# NAME                                   STATUS   ROLES    AGE     VERSION
# gke-kubia-default-pool-271036ba-84s8   Ready    <none>   8m24s   v1.14.10-gke.27
# gke-kubia-default-pool-ef8e6b97-2v19   Ready    <none>   8m24s   v1.14.10-gke.27
# gke-kubia-default-pool-fc207bf0-3zjb   Ready    <none>   8m24s   v1.14.10-gke.27

# Show detailed info of all the cluster nodes
k describe node

# Show detailed info of a cluster node
k describe node gke-kubia-default-pool-271036ba-84s8
```

## Web UI

- GCP: https://console.cloud.google.com/kubernetes
- AWS: ???
