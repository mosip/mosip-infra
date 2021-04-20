# Artifactory

## Install
* Create `artifactory` namespace
```
$ kubectl create namespace artifactory
```
* Helm install
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update
$ helm dep update
$ helm -n artifactory install artifactory mosip/artifactory 
```
