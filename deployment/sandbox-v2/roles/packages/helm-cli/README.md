These tasks install the helm executable. There is some duplication of code as same code is also present in k8cluster role, but the context is slight different, so we have replicated similar code here.  

We DO NOT run this tasks with "become: yes" as the get_helm.sh that is downloaded runs with `sudo`.  Note that if we run this task with `become:yes` it throws exection cause root user's $PATH does not have `/usr/local/bin` where the helm installs itself.  
