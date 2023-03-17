## Step 5 Notes:
After provision aws infra plus apps, i install k8s metrics server :
### Refrence:
[Installing the Kubernetes Metrics Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html)

##### 1- Deploy the Metrics Server
Deploy the Metrics Server with the following command:
```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

##### 2- Verify that the metrics-server deployment is running the desired number of pods with the following command:

```sh
kubectl get deployment metrics-server -n kube-system
```

#####  3- View PODs metrics:
```sh
kubectl top pod
```
-- with the following output:
W0315 00:18:16.808457    9352 top_pod.go:140] Using json format to get metrics. Next release will switch to protocol-buffers, switch early by passing --use-protocol-buffers flag
(Part of output)
| NAME                                | NAME | MEMORY(bytes) |
|-------------------------------------|------|---------------|
| bloaty-mcbloatface-58c98b98d8-4f49s | 1m   | 3Mi           |
| bloaty-mcbloatface-58c98b98d8-4jgpk | 1m   | 3Mi           |
| blue-8475cbdf46-cq8fb               | 1m   | 3Mi           |
| blue-8475cbdf46-nnsfk               | 1m   | 3Mi           |
| canary-v1-64598c676f-56rgz          | 0m   | 3Mi           |
| canary-v1-64598c676f-6pgbg          | 0m   | 3Mi           |
| hello-world-794458d64d-4xwsl        | 2m   | 19Mi          |


----------------------------------------------------
I noticed the hello-world pod is the most memory by 19Mi.

#####  4- Deleting most memory app:
I delete the deployment of hello-world to stop running POD.
```sh
kubectl delete -f project/apps/hello-world/hello.yml
```

It will removes hellow-world pod, with the following output:
deployment.apps "hello-world" deleted
service "hello-world" deleted