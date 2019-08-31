import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)

instance.setSecurityRealm(hudsonRealm)

hudsonRealm.createAccount("admin", "{{ .Values.Master.AdminPassword }}")

def adminStrategy = new GlobalMatrixAuthorizationStrategy()
    adminStrategy.add(Jenkins.ADMINISTER, "admin")
    
instance.setAuthorizationStrategy(adminStrategy)

instance.save()
