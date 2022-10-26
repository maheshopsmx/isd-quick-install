# How to install

1. It clone the repo with released tag, create namespace and template chart it using helm finally apply the template files usng kubectl commands

## Dependency

  - kubectl
  - Helm
  - git
  - curl
 
## command

      curl -o install.sh https://raw.githubusercontent.com/maheshopsmx/isd-quick-install/main/mahesh-curl/case1/install.sh && chmod 700 install.sh && ./install.sh


## Drawbacks 

  - no user inputs and customized values 
  - UI should be accessed only with port-forward
