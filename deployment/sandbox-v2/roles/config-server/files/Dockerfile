FROM openjdk:8
ARG git_uri
ARG config_folder
ARG version
ARG jar_name
ENV env_git_uri=${git_uri}
ENV env_config_folder=${config_folder}
ENV env_version=$(version)
ENV env_jar_name=${jar_name}
WORKDIR /home/config
COPY ${jar_name}-${version}.jar /home/config/${jar_name}.jar
EXPOSE 51000
CMD java -jar -Dspring.cloud.config.server.git.uri=${env_git_uri} -Dspring.cloud.config.server.git.search-paths=${env_config_folder} ${env_jar_name}.jar
