FROM jenkinsci/jnlp-slave

ENV DOCKER_VERSION=17.04.0-ce DOCKER_COMPOSE_VERSION=1.14.0 KUBECTL_VERSION=v1.6.6

USER root
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
		&& tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin \
		&& chmod -R +x /usr/local/bin/docker

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSLO https://kubernetes-helm.storage.googleapis.com/helm-v2.14.0-linux-amd64.tar.gz \
         && tar --strip-components=1 -xvzf helm-v2.14.0-linux-amd64.tar.gz -C /usr/local/bin \
         && chmod +x /usr/local/bin/helm \
         && chmod +x /usr/local/bin/tiller

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
       && apt-get install -y nodejs

RUN  apt-get install -y openjfx

RUN cp /usr/share/java/openjfx/jre/lib/ext/jfxrt.jar /usr/local/openjdk-8/jre/lib/ext

RUN curl -fsSLO https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.gz \
      && tar --strip-components=1 -xvzf node-v10.15.3-linux-x64.tar.gz -C /usr/local

