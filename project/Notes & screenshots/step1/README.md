## Step 1 Notes:
I checked pods by :
```sh
kubectl get pods --all-namespaces
kubectl get pods
```
-- with the following output:
PS E:\aws\aws2\nd087-c3-deployment-roulette> kubectl get pods
| NAME                        	| READY 	| STATUS           	| RESTARTS       	| AGE   	|
|-----------------------------	|-------	|------------------	|----------------	|-------	|
| blue-8475cbdf46-478f8       	| 1/1   	| Running          	| 0              	| 3m50s 	|
| blue-8475cbdf46-cpvtr       	| 1/1   	| Running          	| 0              	| 3m50s 	|
| blue-8475cbdf46-ptgms       	| 1/1   	| Running          	| 0              	| 3m51s 	|
| canary-v1-64598c676f-f657t  	| 1/1   	| Running          	| 0              	| 4m10s 	|
| canary-v1-64598c676f-kms8p  	| 1/1   	| Running          	| 0              	| 4m10s 	|
| canary-v1-64598c676f-smlvm  	| 1/1   	| Running          	| 0              	| 4m10s 	|
| hello-world-d696c5567-5hlxs 	| 0/1   	| CrashLoopBackOff 	| 15 (2m42s ago) 	| 37m   	|

----------------------------------------------------
I noticed the hello-world pod is at CrashLoopBackOff error.

## Checking Pod logs:
```sh
kubectl logs -f  hello-world-d696c5567-5hlxs
```
--With output :
Ready to receive requests on 9000
 * Serving Flask app 'main' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://10.100.1.225:9000/ (Press CTRL+C to quit)
10.100.1.119 - - [06/Mar/2023 19:39:43] "GET /nginx_status HTTP/1.1" 500 -
10.100.1.119 - - [06/Mar/2023 19:39:45] "GET /nginx_status HTTP/1.1" 500 -
Failed health check you want to ping /healthz
10.100.1.119 - - [06/Mar/2023 19:39:47] "GET /nginx_status HTTP/1.1" 500 -
PS E:\aws\aws2\nd087-c3-deployment-roulette> kubectl apply -f project/apps/hello-world
deployment.apps/hello-world configured
service/hello-world unchanged

## Checking Pod description:
```sh
kubectl describe pod hello-world-d696c5567-5hlxs
```
| Type    | Reason    | Age                   | From              | Message                                                                                      |
|---------|-----------|-----------------------|-------------------|----------------------------------------------------------------------------------------------|
| ----    | ------    | ----                  | ----              | -------                                                                                      |
| Normal  | Scheduled | 43m                   | default-scheduler | Successfully assigned udacity/hello-world-d696c5567-5hlxs to ip-10-100-1-119.us-eas.internal |
| Normal  | Pulled    | 43m                   | kubelet           | Successfully pulled image "etapau/hello-world:udacity" in 19.571756414s                      |
| Normal  | Pulled    | 42m                   | kubelet           | Successfully pulled image "etapau/hello-world:udacity" in 225.388392ms                       |
| Normal  | Killing   | 42m (x3 over 43m)     | kubelet           | Container hello-world failed liveness probe, will be restarted                               |
| Warning | Unhealthy | 28m (x28 over 43m)    | kubelet           | Liveness probe failed: HTTP probe failed with statuscode: 500                                |
| Warning | BackOff   | 8m44s (x122 over 40m) | kubelet           | Back-off restarting failed container                                                         |
| Normal  | Pulling   | 3m52s (x17 over 43m)  | kubelet           | Pulling image "etapau/hello-world:udacity"                                                   |

I noticed from commands that ping to /healthz failed, plus an error at Liveness probe failed: HTTP probe failed with statuscode: 500 

## Fixing error:
I check hello.yml file, i replace path: /nginx_status by path: /healthz.
Run:
```sh
kubectl apply -f project/apps/hello-world
```
---------------------------------------------------------
## Check Hello pod and ensure running:
by rerun previous checking pod commands,i noticed 
A new pod had been launched instead of old one, and it is running.

| NAME                         | READY | STATUS  | RESTARTS | AGE |
|------------------------------|-------|---------|----------|-----|
| blue-8475cbdf46-cpvtr        | 1/1   | Running | 0        | 38m |
| blue-8475cbdf46-ptgms        | 1/1   | Running | 0        | 38m |
| canary-v1-64598c676f-f657t   | 1/1   | Running | 0        | 38m |
| canary-v1-64598c676f-kms8p   | 1/1   | Running | 0        | 38m |
| canary-v1-64598c676f-smlvm   | 1/1   | Running | 0        | 38m |
| hello-world-794458d64d-4q598 | 1/1   | Running | 0        | 65s |
---------------------------------------------------------------------
| Type   | Reason    | Age   | From              | Message                                                                                                  |
|--------|-----------|-------|-------------------|----------------------------------------------------------------------------------------------------------|
| ----   | ------    | ----  | ----              | -------                                                                                                  |
| Normal | Scheduled | 3m12s | default-scheduler | Successfully assigned udacity/hello-world-794458d64d-4q598 to ip-10-100-1-119.us-east-2.compute.internal |
| Normal | Pulling   | 3m11s | kubelet           | Pulling image "etapau/hello-world:udacity"                                                               |
| Normal | Pulled    | 3m11s | kubelet           | Successfully pulled image "etapau/hello-world:udacity" in 229.083374ms                                   |
| Normal | Created   | 3m11s | kubelet           | Created container hello-world                                                                            |
| Normal | Started   | 3m11s | kubelet           | Started container hello-world                                                                            |

### Refrence:
[Kubernentes liveness-readiness probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
