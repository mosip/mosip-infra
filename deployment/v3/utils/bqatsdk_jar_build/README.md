# Build Process for BQAT SDK Jar

## Overview
The process involves building the BQAT SDK jar locally and then adding it to the Artifactory pod.

1. **Clone Repository**:
   Clone the bqat-sdk repository to your local machine.
   ```bash
   git clone https://github.com/JanardhanBS-SyncByte/bqat-sdk
   ```

2. **Switch Branch**:
   Navigate to the cloned repository and checkout to the required branch (e.g., develop).
   ```bash
   cd bqat-sdk/
   git checkout develop
   ```

3. **Build with Maven**:
   Ensure you are in the directory containing the `pom.xml` file, then build it using Maven.
   ```bash
   mvn clean install -Dgpg.skip
   ```

4. **Zip the Jar**:
   Zip the generated jar file with its dependencies.
   ```bash
   zip bqat-sdk-0.0.2-jar-with-dependencies.zip bqat-sdk-0.0.2-jar-with-dependencies.jar
   ```

5. **Modify Artifactory Deployment Provide Root Access For The Pod**:
   Update the Artifactory deployment file in the environment to ensure the pod runs with root access.
   ```yaml
   schedulerName: default-scheduler
   securityContext:
     runAsUser: 0
   ```

6. **Export Jar to Artifactory Pod**:
   Copy the built jar to the Artifactory pod in the designated namespace (replace artifactory pod name respectively "eg:artifactory-bqatsdk-577459987c-67pht").
   ```bash
   kubectl -n bqatsdk cp /path/to/bqat-sdk-0.0.2-jar-with-dependencies.zip artifactory-bqatsdk-577459987c-67pht:/usr/share/nginx/html
   ```

7. **Verify Jar in Pod**:
   Access the pod using Execute shell and verify if the jar is successfully copied .
   ```bash
   ls /usr/share/nginx/html
   ```

8. **Login to Node**:
   log in to the node where the pod is running.

9. **Check Docker**:
   View active Docker containers.
   ```bash
   docker ps
   ```

10. **Docker Login**:
    If required, log in to Docker with your credentials.
    ```bash
    docker login
    ```

11. **Commit Changes**:
    Commit the changes to Artifactory Docker image.
    ```bash
    docker commit CONTAINERID IMAGE
    ```

12. **Push to Docker Repo**:
    Push the changes to the Docker repository.
    ```bash
    docker push IMAGE
    ```
 **NOTE: Push the image to required docker hub**   

13. **Deploy Artifactory Image**:
    After pushing changes to docker hub, deploy the Artifactory pod in the `bqatsdk` namespace with the new image created.

14. **Map New Artifactory zip_file_path **: 
   ```
    - name: biosdk_zip_file_path
              value: >-
                http://artifactory-bqatsdk.bqatsdk:80/bqat-sdk-0.0.2-jar-with-dependencies.zip 
   ```


This standardizes the process for building and deploying the BQAT SDK jar.
