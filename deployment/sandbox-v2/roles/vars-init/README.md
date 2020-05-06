The tasks here make sure the Helm variables are in sync with Ansible variables and that we just have one place where we define varables.

It is assumed that all 'modifable' variables are available without any indentation. Eg. 

CORRECT:
sandboxDomain: hello.com


NOT CORRECT:
domains:
  sandboxDomain: hello.com


If the above has to be achieved, the following needs to be done:

domainName: hello.com
domains:
  sandboxDomain: $domainName
