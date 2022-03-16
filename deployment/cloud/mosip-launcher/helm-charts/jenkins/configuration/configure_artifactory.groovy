import jenkins.model.*
import org.jfrog.*
import org.jfrog.hudson.*
import org.jfrog.hudson.util.Credentials;

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("org.jfrog.hudson.ArtifactoryBuilder")

def deployerCredentials = new CredentialsConfig("{{ .Values.Artifactory.username }}", "{{ .Values.Artifactory.password }}", "")
def resolverCredentials = new CredentialsConfig("", "", "")

def sinst = [new ArtifactoryServer(
  "{{ .Values.Artifactory.serverid }}",
  "{{ .Values.Artifactory.url }}",
  deployerCredentials,
  resolverCredentials,
  300,
  false,
  3,
  3 )
]

desc.setArtifactoryServers(sinst)

desc.save()