#!/bin/bash

set -e

kubectl apply -f project/apps/hello-world/hello.yml
kubectl apply -f project/apps/canary/index_v1_html.yml
kubectl apply -f project/apps/canary/canary-v1.yml
kubectl apply -f project/apps/blue-green/index_blue_html.yml
kubectl apply -f project/apps/blue-green/blue.yml
kubectl apply -f project/apps/bloatware/bloatware.yml