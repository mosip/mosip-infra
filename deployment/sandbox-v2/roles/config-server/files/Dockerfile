FROM openjdk:8
ARG git_uri
ARG version
ARG jar_name
WORKDIR /home/config
copy ${jar_name}-${version}.jar /home/config/${jar_name}.jar
EXPOSE 51000
ENV env_git_uri=${git_uri}
CMD java -jar -Dspring.cloud.config.server.git.uri=${env_git_uri} ${jar_name}.jar
