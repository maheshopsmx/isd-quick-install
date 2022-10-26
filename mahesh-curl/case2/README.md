# How to install

It uses the pre-templated manifest using helm, it is stored in git repo and raw data is used to install the package with shell script

## Dependency

   - curl
   - kubectl 
  
## command

      curl -o install.sh https://raw.githubusercontent.com/maheshopsmx/isd-quick-install/main/mahesh-curl/case2/install.sh && chmod 700 install.sh && ./install.sh



## Drawbacks 

  - no user inputs and customized values 
  - UI should be accessed only with port-forward
