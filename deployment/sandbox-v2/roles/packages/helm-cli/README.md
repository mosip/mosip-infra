These tasks install the helm executable. There is some duplication of code as same code is also present in k8cluster role, but the context is slight different, so we have replicated similar code here.  

Helm exe installed in $HOME/bin - this is done because this path is included as a default path ($PATH) and hence works for cases where we ssh into the machine or do a `sudo su`.

