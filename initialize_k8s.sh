#!/bin/bash

set -e

kubectl apply -f project/apps/hello-world
kubectl apply -f project/apps/canary/index_v1_html.yml
kubectl apply -f project/apps/canary/canary-v1.yml
kubectl apply -f project/apps/blue-green