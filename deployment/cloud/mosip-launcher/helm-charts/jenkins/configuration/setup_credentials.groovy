print 'creating credentials for github, docker-registry'
      import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
      import com.cloudbees.plugins.credentials.*
      import com.cloudbees.plugins.credentials.common.*
      import com.cloudbees.plugins.credentials.domains.Domain
      import com.cloudbees.plugins.credentials.impl.*
      import hudson.util.Secret
      import java.nio.file.Files
      import jenkins.model.Jenkins
      import net.sf.json.JSONObject
      import org.jenkinsci.plugins.plaincredentials.impl.*

      
      // get Jenkins instance
      Jenkins jenkins = Jenkins.getInstance()

      // get credentials domain
      def domain = Domain.global()

      // get credentials store
      def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

      // parameters for scm credentials
      def jenkinsScmKeyParameters = [
        description:  'SCM SSH Key',
        id:           '{{ .Values.Scm.credentialsid }}',
        secret:       '',
        userName:     '{{ .Values.Scm.username }}',
        key:          new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource('''{{ .Values.Scm.privatekey }}''')
      ]
      // parameters for docker-registry credentials
      def jenkinsUsernamePasswordDockerregistryParameter = [
        description:  'Credentials to connect to Docker registry',
        id:           '{{ .Values.Docker.registryid }}',
        secret:       '{{ .Values.Dockerregistry.password }}',
        userName:     '{{ .Values.Dockerregistry.username }}'
      ]
      // define private key
      def privateKeyForScm = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        jenkinsScmKeyParameters.id,
        jenkinsScmKeyParameters.userName,
        jenkinsScmKeyParameters.key,
        jenkinsScmKeyParameters.secret,
        jenkinsScmKeyParameters.description
      )
      def UsernamePasswordForDockerRegistry = new UsernamePasswordCredentialsImpl(
        CredentialsScope.GLOBAL,
        jenkinsUsernamePasswordDockerregistryParameter.id,
        jenkinsUsernamePasswordDockerregistryParameter.description,
        jenkinsUsernamePasswordDockerregistryParameter.userName,
        jenkinsUsernamePasswordDockerregistryParameter.secret
      )


      // add credential to store
      store.addCredentials(domain, privateKeyForScm)
      store.addCredentials(domain, UsernamePasswordForDockerRegistry)

      // save to disk
      jenkins.save()