FROM openjdk:8
ARG config_git_path
COPY target/*.jar /tmp/ 
WORKDIR /tmp
EXPOSE 8888
ENV env_config_git_path=${config_git_path}
CMD java -Dspring.cloud.config.server.native.search-locations=file:///${env_config_git_path} -jar mosip-config-service-0.0.1.jar  
