# [Chapter 3.3] Running my first app on K8s

> Usually, to deploy an application, you’d prepare a JSON or YAML file describing all the components that your application consists of and apply that file to your cluster. This would be the declarative approach.

> The interaction with Kubernetes consists mainly of the creation and manipulation of objects via its API.

> In Kubernetes, instead of deploying individual containers, you deploy groups of co-located containers – so-called pods.

> The term scheduling refers to the assignment of the pod to a node. The pod runs immediately, not at some point in the future.

![](https://user-images.githubusercontent.com/7563926/79015707-55bda400-7b3b-11ea-9200-3003c81318c3.png)

![](https://user-images.githubusercontent.com/7563926/79016994-4c820680-7b3e-11ea-9aa4-67eb508e351f.png)

## Deploying my app in an imperative way

```sh
# This can be GKE but I use minikube for demonstration here.
minikube start
minikube status

# List all the images
docker images

# Create a deployment objects specifying:
# - the name of the object to be created and
# - a container image for the deployment
k create deployment kubia --image=mnishiguchi/kubia
# deployment.apps/kubia created

# List all deployment objects that currently exist in the cluster
k get deployments
# NAME    READY   UP-TO-DATE   AVAILABLE   AGE
# kubia   0/1     1            0           10s

k get pods
# NAME                    READY   STATUS    RESTARTS   AGE
# kubia-9678b695d-9zmd9   1/1     Running   0          105s

k describe pod
# ...
# Events:
#   Type    Reason     Age   From               Message
#   ----    ------     ----  ----               -------
#   Normal  Scheduled  2m8s  default-scheduler  Successfully assigned default/kubia-9678b695d-9zmd9 to minikube
#   Normal  Pulling    2m7s  kubelet, minikube  Pulling image "mnishiguchi/kubia"
#   Normal  Pulled     84s   kubelet, minikube  Successfully pulled image "mnishiguchi/kubia"
#   Normal  Created    83s   kubelet, minikube  Created container kubia
#   Normal  Started    83s   kubelet, minikube  Started container kubia
```

## Exposing my app to the world

> To make the pod accessible externally, you’ll expose it by creating a Service object.

```sh
# Create a service object that
# - exposes all pods that belong to the kubia deployment
# - has the pods to be accessible from outside the cluster via a load balancer
# - has the app listen on port 8080
# Note: If the object name is omitted, it inherits the name of the Deployment.
k expose deployment kubia --type=LoadBalancer --port 8080
# service/kubia exposed

# List all supported object types
k api-resources
a
k get svc
# NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          17d
# kubia        LoadBalancer   10.110.139.155   <pending>     8080:32313/TCP   6m17s
```

## Understanding load balancer services

> While Kubernetes allows you to create so-called LoadBalancer services, it doesn’t provide the load balancer itself. If your cluster is deployed in the cloud, Kubernetes can ask the cloud infrastructure to provision a load balancer and configure it to forward traffic into your cluster. The infrastructure tells Kubernetes the IP address of the load balancer and this becomes the external address of your service.

![](https://user-images.githubusercontent.com/7563926/79018650-59a0f480-7b42-11ea-8c8c-46169c16a45a.png)

```sh
# Note: If you use Minikube to create the cluster, no load balancer is created.
# Kubectl always shows the external IP as <pending> but you can access the service in another way.
k get svc kubia
# NAME    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# kubia   LoadBalancer   10.110.139.155   <pending>     8080:32313/TCP   22m
```

### [Minikube] Easy way to access your service when no load balancer is available

```sh
# This is a workaround to get an external IP for minikube.
minikube service kubia
# http://192.168.64.2:32313

# It is actually the IP of the Minikube virtual machine.
minikube ip
# 192.168.64.2

# The port 30838 is the so-called node port. It’s the port on the worker node that forwards connections to your service.
kubectl get svc
# NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          17d
# kubia        LoadBalancer   10.110.139.155   <pending>     8080:32313/TCP   34m
```

> If you know the IP of at least one of your worker nodes, you should be able to access your service through this IP:port combination, provided that firewall rules do not prevent you from accessing the port.

![](https://user-images.githubusercontent.com/7563926/79020230-4859e700-7b46-11ea-8bb7-1609de129b6a.png)

## Horizontally scaling the app

op

> One of the major benefits of running applications in containers is the ease with which you can scale your application deployments.

> Instead of telling Kubernetes what to do, you simply set a new desired state of the system and let Kubernetes achieve it.

### Increasing the number of running app instances

```sh
k scale deploy kubia --replicas=3
# deployment.apps/kubia scaled

k get deploy
# NAME    READY   UP-TO-DATE   AVAILABLE   AGE
# kubia   3/3     3            3           73m

k get po
# NAME                    READY   STATUS    RESTARTS   AGE
# kubia-9678b695d-9zmd9   1/1     Running   0          79m
# kubia-9678b695d-sbhxf   1/1     Running   0          6m44s
# kubia-9678b695d-z7585   1/1     Running   0          49s

# Show the host node of the pods
k get po -o wide
# NAME                    READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
# kubia-9678b695d-9zmd9   1/1     Running   0          80m     172.17.0.4   minikube   <none>           <none>
# kubia-9678b695d-sbhxf   1/1     Running   0          7m29s   172.17.0.6   minikube   <none>           <none>
# kubia-9678b695d-z7585   1/1     Running   0          94s     172.17.0.5   minikube   <none>           <none>
```

> Note that you haven’t instructed Kubernetes what to do. You haven’t told it to add two more pods. You just set the new desired number of replicas and let Kubernetes determine what action it must take to reach the new desired state.

```sh
# Each request arrives at a different pod in random order.
curl http://192.168.64.2:32313
# You've hit kubia-9678b695d-z7585

curl http://192.168.64.2:32313
# You've hit kubia-9678b695d-9zmd9

curl http://192.168.64.2:32313
# You've hit kubia-9678b695d-sbhxf
```

![](https://user-images.githubusercontent.com/7563926/79021727-4e51c700-7b4a-11ea-9fbd-1fcab0b5a213.png)

## Understanding the deployed app

> ...you’re not the one who manages the cluster, you don’t even need to worry about the physical view of the cluster. If everything works as expected, the logical view is all you need to worry about.

![](https://user-images.githubusercontent.com/7563926/79047066-6ffe8d00-7be2-11ea-894b-8ec7bee67763.png)

### The objects that I have created in the K8s API either directly or indirectly

- The deployment object I created
  - represents an application deployment
  - specifies which container image contains your application and how many replicas of the application Kubernetes should run
- The pod objects that were automatically created based on the deployment
  - represents each replica
- The service object I created manually
  - represents a single communication entry point to these replicas

## Understanding the pods

- Each pod definition contains one or more containers that make up the pod.
- When k8s brings a pod to life, it runs all the containers specified in its definition.
- As long as a Pod object exists, k8s will do its best to ensure that its containers keep running.
- It only shuts them down when the Pod object is deleted.
- You almost never create pods directly but use a Deployment instead
- A pod may disappear at any time. When pods are created through a Deployment, a missing pod is immediately replaced with a new one. It’s a completely new pod, with a new IP address.

## Understanding why you need a service

- The service gives you a single IP address to talk to your pods, regardless of how many replicas are currently deployed.
- When you create a service, it is assigned a static IP address that never changes during lifetime of the service.
- Instead of connecting directly to the pod, clients should connect to the IP of the service. This ensures that their connections are always routed to a healthy pod, even if the set of pods behind the service is constantly changing. It also ensures that the load is distributed evenly across all pods should you decide to scale the deployment horizontally.
