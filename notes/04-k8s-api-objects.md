# [Chapter 4.1] K8s API objects

## K8s API

- the central point of interaction with the cluster
- an HTTP-based REST API
- the k8s API objects represent the configuration of the cluster.

## version

- multiple versions of the same kind can exist
- Different versions can have different fields or default values

## the structure of an object manifest

```sh
# Show docs
k api-resources
k explain no
k explain no.spec
k explain no.metadata | less
k explain no.status | less

# Show the complete hierarchical list of fields without the descriptions
k explain po --recursive
```

### Type metedata

- specifies the type of the resource

### Object metadata

- specifies the name and other identifying information

### Spec

- specifies the state you want the resource to be in
- my desired state of the resource

### Status

- the actual current state of the resource

## Inspecting objects

- a node is a machine in the cluster

```sh
k get no
# NAME       STATUS     ROLES    AGE    VERSION
# m01        NotReady   master   202d   v1.17.3
# minikube   Ready      <none>   186d   v1.19.2

# ---
# A: Display the complete YAML manifest of an object through kubectl
# - Hard to read due to alphabetically-ordered keys
# ---

# in yaml format
k get no minikube -o yaml | less
k get no minikube -o yaml | yq read - status.conditions
# - lastHeartbeatTime: "2020-10-12T18:13:29Z"
#   lastTransitionTime: "2020-10-12T09:15:39Z"
#   message: kubelet has sufficient memory available
#   reason: KubeletHasSufficientMemory
#   status: "False"
#   type: MemoryPressure
# ...

# in json format
k get no minikube -o json | jq .status.conditions
# [
#   {
#     "lastHeartbeatTime": "2020-10-12T18:03:27Z",
#     "lastTransitionTime": "2020-10-12T09:15:39Z",
#     "message": "kubelet has sufficient memory available",
#     "reason": "KubeletHasSufficientMemory",
#     "status": "False",
#     "type": "MemoryPressure"
#   },
#   ...
# ]

# ---
# B: Directly acccess the k8s API
# ---

k proxy
# Starting to serve on 127.0.0.1:8001

# Now we can access the API using that proxy URL.
curl 127.0.0.1:8001/api/v1/nodes/minikube


# ---
# C: Using the `kubectl describe` command
# - more user-friendly than JSON or YAML
# ---

kubectl describe no minikube | less
```

## Event object

- emitted by controllers to reveal what they have done
- two types of events:
  - normal
  - warning
- deleted one hour after creation

```sh
# Show docs
k explain events
```

```sh
k delete deployment --all
# deployment.apps "kubia" deleted

k get ev
# LAST SEEN   TYPE     REASON    OBJECT                      MESSAGE
# 3s          Normal   Killing   pod/kubia-d9899768f-k9z59   Stopping container kubia

k get ev -o wide
# LAST SEEN   TYPE     REASON    OBJECT                      SUBOBJECT                SOURCE              MESSAGE                    FIRST SEEN   COUNT   NAME
# 12m         Normal   Killing   pod/kubia-d9899768f-k9z59   spec.containers{kubia}   kubelet, minikube   Stopping container kubia   12m          1       kubia-d9899768f-k9z59.163d546d8fe764e6

k get ev --field-selector type=warning
# No resources found.
```
