To use this server create another git repo in your local disk that contains all the properties files, yml files etc.  Point  `spring.cloud.config.server.git.uri` key in `src/main/resources/application.properties` to point to this repo root.

Run spring boot from root of this repo as  
`$ mvn spring-boot:run`  

