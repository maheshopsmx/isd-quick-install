#!/bin/bash

set -x

kubectl create namespace opsmx-isd
kubectl -n opsmx-isd apply -f https://raw.githubusercontent.com/OpsMx/isd-quick-install/main/isd40/isd-gitea-quick.yaml
while [ "$(kubectl get pods -n opsmx-isd -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
   echo "Waiting for Broker to be ready."
   if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
    echo "running"
    kubectl -n opsmx-isd port-forward svc/oes-ui 8089
    else
    echo "not running"
    kubectl -n opsmx-isd port-forward svc/oes-ui 8080
    fi
done

