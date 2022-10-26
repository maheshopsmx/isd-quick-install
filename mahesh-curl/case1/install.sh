#! /bin/bash
## kubectl should be installed 
## helm should be installed 
git clone -b isdargo-4.1.0 https://github.com/OpsMx/enterprise-argo.git /tmp/enterprise-argo
cd /tmp/enterprise-argo/charts/isdargo
helm template isd-argo . -f values.yaml  -n isdargo > install.yaml
kubectl create ns isd-argo
kubectl apply -f install.yaml -n isd-argo
