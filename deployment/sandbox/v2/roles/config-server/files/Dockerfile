FROM openjdk:8
ARG config_git_path
ARG version
WORKDIR /home/config
copy kernel-config-server-${version}.jar /home/config/kernel-config-server.jar
EXPOSE 51000
ENV env_config_git_path=${config_git_path}
CMD java -Dspring.profiles.active=native -Dspring.cloud.config.server.native.search-locations=file:///${env_config_git_path} -jar kernel-config-server.jar
