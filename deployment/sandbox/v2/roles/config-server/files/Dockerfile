FROM openjdk:8
ARG git_uri
ARG version
ARG git_search_paths 
WORKDIR /home/config
copy kernel-config-server-${version}.jar /home/config/kernel-config-server.jar
EXPOSE 51000
ENV env_git_uri=${git_uri}
ENV env_git_search_paths=${git_search_paths}
#CMD java -jar -Dspring.cloud.config.server.git.uri=${env_git_uri} -Dspring.cloud.config.server.git.search-paths=${env_git_search_paths} kernel-config-server.jar
CMD java -jar -Dspring.cloud.config.server.git.uri=${env_git_uri} kernel-config-server.jar
