# [Chapter 01] Introducing k8s

## What is k8s? Why is it adopted widely?

- Kubernetes is Greek for helmsman. As a ship’s captain oversees the ship while the helmsman steers it, you oversee your computer cluster, while Kubernetes performs the day-to-day management tasks.
- Kubernetes uses a declarative model to describe application deployments.
- Kubernetes is like an operating system for the cluster. It abstracts the infrastructure and presents all computers in a data center as one large, contiguous deployment area.
- Microservice-based applications are more difficult to manage than monolithic applications. The more microservices you have, the more you need to automate their management with a system like Kubernetes.
- Kubernetes helps both development and operations teams to do what they do best. It frees them from mundane tasks and introduces a standard way of deploying applications both on-premises and in any cloud.
- Using Kubernetes allows developers to deploy applications without the help of system administrators. It reduces operational costs through better utilization of existing hardware, automatically adjusts your system to load fluctuations, and heals itself and the applications running on it.
- A Kubernetes cluster consists of master and worker nodes. The master nodes run the Control Plane, which controls the entire cluster, while the worker nodes run the deployed applications or workloads, and therefore represent the Workload Plane.
- Using Kubernetes is simple, but managing it is hard. An inexperienced team should use a Kubernetes-as-a-Service offering instead of deploying Kubernetes by itself.

## How does k8s work?

- k8s schedules the components of a distributed application onto individual computers in the underlying computer cluster and acts as an interface between the application and the cluster.
- We can rely on k8s to provide infrastructure-related mechanisms including:
  - service discovery
  - horizontal scaling
  - load-balancing
  - self-healing
  - leader election

![Screen Shot 2020-03-22 at 12 02 55 PM](https://user-images.githubusercontent.com/7563926/77254360-f143af00-6c36-11ea-83ce-d10a71700eba.png)
![Screen Shot 2020-03-22 at 12 08 21 PM](https://user-images.githubusercontent.com/7563926/77254350-e9840a80-6c36-11ea-91fc-e70bbaf8f6ae.png)
![Screen Shot 2020-03-22 at 12 09 39 PM](https://user-images.githubusercontent.com/7563926/77254353-ebe66480-6c36-11ea-9168-5a63fbeca679.png)

## Benefits of using k8s

- self-service deployment of applications
- reducing costs via better infrastructure utilization
- automatically adjusting to changing load
- keeping applications running smoothly
- simplifying application development

## Architecture of a k8s cluster

![Screen Shot 2020-03-22 at 12 14 57 PM](https://user-images.githubusercontent.com/7563926/77254356-edb02800-6c36-11ea-926d-412d25fd5984.png)
![Screen Shot 2020-03-22 at 12 15 41 PM](https://user-images.githubusercontent.com/7563926/77254357-ef79eb80-6c36-11ea-8659-5917529a7370.png)
![Screen Shot 2020-03-22 at 12 18 34 PM](https://user-images.githubusercontent.com/7563926/77254431-50a1bf00-6c37-11ea-88c3-4489f91e2413.png)
![Screen Shot 2020-03-22 at 12 19 35 PM](https://user-images.githubusercontent.com/7563926/77254453-6c0cca00-6c37-11ea-863f-e6f2d4111dc3.png)
