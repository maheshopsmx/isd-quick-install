#!/bin/bash

#set -x

kubectl create namespace opsmx-isd
kubectl -n opsmx-isd apply -f https://raw.githubusercontent.com/OpsMx/isd-quick-install/main/isd40/isd-gitea-quick.yaml
echo \"Waiting for all Spinnaker and OES Services to come-up\"
wait_period=0
while true
    do
    kubectl get po -n opsmx-isd -o jsonpath='{range .items[*]}{..metadata.name}{"\t"}{..containerStatuses..ready}{"\n"}{end}' > /tmp/inst.status
    ## NON-HA
    CLOUDDRIVER=$(grep spin-clouddriver /tmp/inst.status |grep -v deck | awk '{print $2}')
    ECHO=$(grep spin-echo /tmp/inst.status | awk '{print $2}')
    ## HA
    CLOUDRO=$(grep spin-clouddriver-ro /tmp/inst.status |grep -v deck | awk '{print $2}')
    CLOUDRODECK=$(grep spin-clouddriver-ro-deck /tmp/inst.status | awk '{print $2}')
    CLOUDRW=$(grep spin-clouddriver-rw /tmp/inst.status | awk '{print $2}')
    CLOUDCACHING=$(grep spin-clouddriver-caching /tmp/inst.status | awk '{print $2}')
    DECK=$(grep spin-deck /tmp/inst.status | awk '{print $2}')
    ECHOWORKER=$(grep spin-echo-worker /tmp/inst.status | awk '{print $2}')
    ECHOSCHEDULER=$(grep spin-echo-scheduler  /tmp/inst.status | awk '{print $2}')
    FRONT=$(grep spin-front /tmp/inst.status  | awk '{print $2}')
    GATE=$(grep spin-gate /tmp/inst.status | awk '{print $2}')
    IGOR=$(grep spin-igor /tmp/inst.status | awk '{print $2}')
    ORCA=$(grep spin-orca /tmp/inst.status | awk '{print $2}')
    FIAT=$(grep spin-fiat /tmp/inst.status | awk '{print $2}')
    #ROSCO=$(grep spin-rosco /tmp/inst.status | awk '{print $2}')
    ## AUTOPILOT
    SAPOR=$(grep oes-sapor /tmp/inst.status | awk '{print $2}')
    PLATFORM=$(grep oes-platform /tmp/inst.status | awk '{print $2}')
    AUTOPILOT=$(grep oes-autopilot /tmp/inst.status | awk '{print $2}')
    wait_period=$(($wait_period+10))
    READYBASIC=$([ "$DECK" == "true" ] && [ "$CLOUDCACHING" == "true" ] && [ "$CLOUDRO" == "true" ] && [ "$CLOUDRW" == "true" ] && [ "$CLOUDRODECK" == "true" ] && [ "$FRONT" == "true" ] && [ "$ORCA" == "true" ]  && [ "$ECHOWORKER" == "true" ] && [ "$ECHOSCHEDULER" == "true" ] && [ "$SAPOR" == "true" ] && [ "$PLATFORM" == "true" ] && [ "$AUTOPILOT" == "true" ] && [ "$GATE" == "true" ] && [ "$IGOR" == "true" ]; echo $(($? == 0)) )
    READY=$READYBASIC
    if [ $READY == 1 ] ;
        then
            echo \"Spinnaker and OES services are Up and Ready..\"
            sleep 5
            if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
                 echo "another serice is running on port 8080 using 8089"
                 kubectl -n opsmx-isd port-forward svc/oes-ui 8089
            else
                 echo "No service is not running on 8080 using 8080"
                 kubectl -n opsmx-isd port-forward svc/oes-ui 8080
            fi
    else
        if [ $wait_period -gt 2000 ];
        then
            echo \"Script is timed out as the Spinnaker is not ready yet.......\"
            break
        else
            echo \"Waiting for Spinnaker services to be ready\"
            kubectl get po -n opsmx-isd | grep -v Running | xargs kubectl delete po -n opsmx-isd
            sleep 1m
        fi
    fi
done
