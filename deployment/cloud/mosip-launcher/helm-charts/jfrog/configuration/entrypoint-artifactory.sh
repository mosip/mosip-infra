#!/bin/bash
#
# An entrypoint script for Artifactory to allow custom setup before server starts
#

: ${ARTIFACTORY_USER_NAME:=artifactory}
: ${ARTIFACTORY_USER_ID:=1030}
: ${ARTIFACTORY_HOME:=/opt/jfrog/artifactory}
: ${ARTIFACTORY_DATA:=/var/opt/jfrog/artifactory}
: ${ACCESS_ETC_FOLDER=${ARTIFACTORY_DATA}/access/etc}
ART_ETC=$ARTIFACTORY_DATA/etc
DB_PROPS=${ART_ETC}/db.properties

: ${RECOMMENDED_MAX_OPEN_FILES:=32000}
: ${MIN_MAX_OPEN_FILES:=10000}

: ${RECOMMENDED_MAX_OPEN_PROCESSES:=1024}

export ARTIFACTORY_PID=${ARTIFACTORY_HOME}/run/artifactory.pid

DEFAULT_SERVER_XML_ARTIFACTORY_PORT=8081
DEFAULT_SERVER_XML_ARTIFACTORY_MAX_THREADS=200
DEFAULT_SERVER_XML_ACCESS_MAX_THREADS=50

logger() {
    DATE_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    if [ -z "$CONTEXT" ]
    then
        CONTEXT=$(caller)
    fi
    MESSAGE=$1
    CONTEXT_LINE=$(echo "$CONTEXT" | awk '{print $1}')
    CONTEXT_FILE=$(echo "$CONTEXT" | awk -F"/" '{print $NF}')
    printf "%s %05s %s %s\n" "$DATE_TIME" "[$CONTEXT_LINE" "$CONTEXT_FILE]" "$MESSAGE"
    CONTEXT=
}

errorExit () {
    logger "ERROR: $1"; echo
    exit 1
}

warn () {
    logger "WARNING: $1"
}

# Print on container startup information about Dockerfile location
printDockerFileLocation() {
    logger "Dockerfile for this image can found inside the container."
    logger "To view the Dockerfile: 'cat /docker/artifactory-oss/Dockerfile.artifactory'."
}

# Check the max open files and open processes set on the system
checkULimits () {
    logger "Checking open files and processes limits"

    CURRENT_MAX_OPEN_FILES=$(ulimit -n)
    logger "Current max open files is $CURRENT_MAX_OPEN_FILES"

    if [ ${CURRENT_MAX_OPEN_FILES} != "unlimited" ] && [ "$CURRENT_MAX_OPEN_FILES" -lt "$RECOMMENDED_MAX_OPEN_FILES" ]; then
        if [ "$CURRENT_MAX_OPEN_FILES" -lt "$MIN_MAX_OPEN_FILES" ]; then
            errorExit "Max number of open files $CURRENT_MAX_OPEN_FILES, is too low. Cannot run Artifactory!"
        fi

        warn "Max number of open files $CURRENT_MAX_OPEN_FILES is low!"
        warn "You should add the parameter '--ulimit nofile=${RECOMMENDED_MAX_OPEN_FILES}:${RECOMMENDED_MAX_OPEN_FILES}' to your the 'docker run' command."
    fi

    CURRENT_MAX_OPEN_PROCESSES=$(ulimit -u)
    logger "Current max open processes is $CURRENT_MAX_OPEN_PROCESSES"

    if [ "$CURRENT_MAX_OPEN_PROCESSES" != "unlimited" ] && [ "$CURRENT_MAX_OPEN_PROCESSES" -lt "$RECOMMENDED_MAX_OPEN_PROCESSES" ]; then
        warn "Max number of processes $CURRENT_MAX_OPEN_PROCESSES is too low!"
        warn "You should add the parameter '--ulimit noproc=${RECOMMENDED_MAX_OPEN_PROCESSES}:${RECOMMENDED_MAX_OPEN_PROCESSES}' to your the 'docker run' command."
    fi
}

configureServerXml () {
    logger "Customising Tomcat server.xml if needed"

    # List of all available variables with default values if needed
    server_xml_variables="""
SERVER_XML_ARTIFACTORY_PORT=${DEFAULT_SERVER_XML_ARTIFACTORY_PORT}
SERVER_XML_ARTIFACTORY_MAX_THREADS=${DEFAULT_SERVER_XML_ARTIFACTORY_MAX_THREADS}
SERVER_XML_ACCESS_MAX_THREADS=${DEFAULT_SERVER_XML_ACCESS_MAX_THREADS}
SERVER_XML_ARTIFACTORY_EXTRA_CONFIG
SERVER_XML_ACCESS_EXTRA_CONFIG
SERVER_XML_EXTRA_CONNECTOR
"""

    if env | grep ^SERVER_XML > /dev/null; then
        local server_xml=${ARTIFACTORY_HOME}/tomcat/conf/server.xml
        local server_xml_template=${ARTIFACTORY_HOME}/server.xml.template
        [ -f ${server_xml} ] || errorExit "${server_xml} not found"
        [ -f ${server_xml_template} ] || errorExit "${server_xml_template} not found"

        # Loop over all variables and replace with final value
        for v in ${server_xml_variables}; do
            key=$(echo ${v} | awk -F= '{print $1}')
            default=$(echo ${v} | awk -F= '{print $2}')
            value=${!key}

            # Set final value (fall back to default if exists)
            final_value=
            if [ ! -z "${value}" ]; then
                final_value=${value}
            elif [ ! -z "${default}" ]; then
                final_value=${default}
            fi

            # Log only if an actual value is found (not default)
            if [ ! -z "${value}" ]; then
                logger "Replacing ${key} with ${final_value}"
            fi
            sed -i "s,${key},${final_value},g" ${server_xml_template} || errorExit "Updating ${key} in ${server_xml_template} failed"
        done

        # Save original and replace with the template
        if [ ! -f ${server_xml}.orig ]; then
            logger "Saving ${server_xml} as ${server_xml}.orig"
            mv -f ${server_xml} ${server_xml}.orig || errorExit "Moving ${server_xml} to ${server_xml}.orig failed"
        fi
        cp -f ${server_xml_template} ${server_xml} || errorExit "Copying ${server_xml_template} to ${server_xml} failed"
    else
        logger "No Tomcat server.xml customizations found"
    fi
}

testReadWritePermissions () {
    local dir_to_check=$1
    local error=false

    [ -d ${dir_to_check} ] || errorExit "'${dir_to_check}' is not a directory"

    local test_file=${dir_to_check}/test-permissions

    # Write file
    if echo test > ${test_file} 1> /dev/null 2>&1; then
        # Write succeeded. Testing read...
        if cat ${test_file} > /dev/null; then
            rm -f ${test_file}
        else
            error=true
        fi
    else
        error=true
    fi

    if [ ${error} == true ]; then
        return 1
    else
        return 0
    fi
}

# Test directory has read/write permissions for current user
testDirectoryPermissions () {
    local dir_to_check=$1
    local error=false

    [ -d ${dir_to_check} ] || errorExit "'${dir_to_check}' is not a directory"

    local id_str="'${ARTIFACTORY_USER_NAME}' (id ${ARTIFACTORY_USER_ID})"
    local u_id=$(id -u)
    if [ "${u_id}" != ${ARTIFACTORY_USER_ID} ]; then
        id_str="id ${u_id}"
    fi

    logger "Testing directory ${dir_to_check} has read/write permissions for user ${id_str}"

    if testReadWritePermissions ${dir_to_check}; then
        # Checking also sub directories (in cases of upgrade + uid change)
        local file_list=$(ls -1 ${dir_to_check})
        if [ ! -z "${file_list}" ]; then
            for d in ${file_list}; do
                if [ -d ${dir_to_check}/${d} ]; then
                    testReadWritePermissions ${dir_to_check}/${d} || error=true
                fi
            done
        fi
    else
        error=true
    fi

    if [ "${error}" == true ]; then
        local stat_data=$(stat -Lc "Directory: %n, permissions: %a, owner: %U, group: %G" ${dir_to_check})
        logger "###########################################################"
        logger "${dir_to_check} DOES NOT have proper permissions for user ${id_str}"
        logger "${stat_data}"
        logger "Mounted directory must have read/write permissions for user ${id_str}"
        logger "###########################################################"
        errorExit "Directory ${dir_to_check} has bad permissions for user ${id_str}"
    fi
    logger "Permissions for ${dir_to_check} are good"
}

setupDataDirs () {
    logger "Setting up Artifactory data directories if missing"
    testDirectoryPermissions ${ARTIFACTORY_DATA}
    [ -d ${ARTIFACTORY_DATA}/etc ]      || mkdir -pv ${ARTIFACTORY_DATA}/etc      || errorExit "Creating ${ARTIFACTORY_DATA}/etc folder failed"
    [ -d ${ARTIFACTORY_DATA}/data ]     || mkdir -pv ${ARTIFACTORY_DATA}/data     || errorExit "Creating ${ARTIFACTORY_DATA}/data folder failed"
    [ -d ${ARTIFACTORY_DATA}/logs ]     || mkdir -pv ${ARTIFACTORY_DATA}/logs     || errorExit "Creating ${ARTIFACTORY_DATA}/logs folder failed"
    [ -d ${ARTIFACTORY_DATA}/backup ]   || mkdir -pv ${ARTIFACTORY_DATA}/backup   || errorExit "Creating ${ARTIFACTORY_DATA}/backup folder failed"
    [ -d ${ARTIFACTORY_DATA}/access ]   || mkdir -pv ${ARTIFACTORY_DATA}/access   || errorExit "Creating ${ARTIFACTORY_DATA}/access folder failed"
    [ -d ${ARTIFACTORY_DATA}/metadata ] || mkdir -pv ${ARTIFACTORY_DATA}/metadata || errorExit "Creating ${ARTIFACTORY_DATA}/metadata folder failed"
}

setAccessCreds() {
    ACCESS_SOURCE_IP_ALLOWED=${ACCESS_SOURCE_IP_ALLOWED:-127.0.0.1}
    ACCESS_CREDS_FILE=${ACCESS_ETC_FOLDER}/bootstrap.creds
    if [ ! -z "${ACCESS_USER}" ] && [ ! -z "${ACCESS_PASSWORD}" ] && [ ! -f ${ACCESS_CREDS_FILE} ] ; then
        logger "Creating bootstrap.creds using ACCESS_USER and ACCESS_PASSWORD env variables"
        mkdir -pv ${ACCESS_ETC_FOLDER} || errorExit "Couldn't create ${ACCESS_ETC_FOLDER}"
        echo "${ACCESS_USER}@${ACCESS_SOURCE_IP_ALLOWED}=${ACCESS_PASSWORD}" > ${ACCESS_CREDS_FILE}
        chmod 600 ${ACCESS_CREDS_FILE} || errorExit "Setting permission on ${ACCESS_CREDS_FILE} failed"
    fi
}

setMasterKey() {
    ARTIFACTORY_SECURITY_FOLDER=${ART_ETC}/security
    ARTIFACTORY_MASTER_KEY_FILE=${ARTIFACTORY_SECURITY_FOLDER}/master.key
    if [ ! -z "${ARTIFACTORY_MASTER_KEY}" ] ; then
        logger "Creating master.key using ARTIFACTORY_MASTER_KEY environment variable"
        mkdir -pv ${ARTIFACTORY_SECURITY_FOLDER} || errorExit "Creating folder ${ARTIFACTORY_SECURITY_FOLDER} failed"
        echo "${ARTIFACTORY_MASTER_KEY}" > "${ARTIFACTORY_MASTER_KEY_FILE}"
    fi

    if [ -f "${ARTIFACTORY_MASTER_KEY_FILE}" ] ; then
        chmod 600 ${ARTIFACTORY_MASTER_KEY_FILE} || errorExit "Setting permission on ${ARTIFACTORY_MASTER_KEY_FILE} failed"
    fi
}

# Wait for DB port to be accessible
waitForDB () {
    local PROPS_FILE=$1
    local DB_TYPE=$2

    [ -f "$PROPS_FILE" ] || errorExit "$PROPS_FILE does not exist"

    local DB_HOST_PORT=
    local TIMEOUT=30
    local COUNTER=0

    # Extract DB host and port
    case "${DB_TYPE}" in
        postgresql|mysql|mariadb)
            DB_HOST_PORT=$(grep -e '^url=' "$PROPS_FILE" | sed -e 's,^.*:\/\/\(.*\)\/.*,\1,g' | tr ':' '/')
        ;;
        oracle)
            DB_HOST_PORT=$(grep -e '^url=' "$PROPS_FILE" | sed -e 's,.*@\(.*\):.*,\1,g' | tr ':' '/')
        ;;
        mssql)
            DB_HOST_PORT=$(grep -e '^url=' "$PROPS_FILE" | sed -e 's,^.*:\/\/\(.*\);databaseName.*,\1,g' | tr ':' '/')
        ;;
        *)
            errorExit "DB_TYPE $DB_TYPE not supported"
        ;;
    esac

    logger "Waiting for DB $DB_TYPE to be ready on $DB_HOST_PORT within $TIMEOUT seconds"

    while [ $COUNTER -lt $TIMEOUT ]; do
        (</dev/tcp/$DB_HOST_PORT) 2>/dev/null
        if [ $? -eq 0 ]; then
            logger "DB $DB_TYPE up in $COUNTER seconds"
            return 1
        else
            logger "."
            sleep 1
        fi
        let COUNTER=$COUNTER+1
    done

    return 0
}

setMaxDBConnections () {
    logger "Setting DB max connections if needed"

    if [ ! -z "${DB_POOL_MAX_ACTIVE}" ]; then
        # Check DB_POOL_MAX_ACTIVE is a valid positive integer
        [[ ${DB_POOL_MAX_ACTIVE} =~ ^[0-9]+$ ]] || errorExit "DB_POOL_MAX_ACTIVE (${DB_POOL_MAX_ACTIVE}) is not a valid number"

        logger "Setting pool.max.active=${DB_POOL_MAX_ACTIVE}"

        # Just in case file already has the property
        grep pool.max.active ${DB_PROPS} > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            sed -i "s,pool.max.active=.*,pool.max.active=${DB_POOL_MAX_ACTIVE},g" ${DB_PROPS} || errorExit "Updating pool.max.active=${DB_POOL_MAX_ACTIVE} in ${DB_PROPS} failed"
        else
            echo "pool.max.active=${DB_POOL_MAX_ACTIVE}" >> ${DB_PROPS} || errorExit "Writing pool.max.active=${DB_POOL_MAX_ACTIVE} to ${DB_PROPS} failed"
        fi

        if [ ! -z "${DB_POOL_MAX_IDLE}" ]; then
            # Check DB_POOL_MAX_IDLE is a valid positive integer
            [[ ${DB_POOL_MAX_IDLE} =~ ^[0-9]+$ ]] || errorExit "DB_POOL_MAX_IDLE (${DB_POOL_MAX_IDLE}) is not a valid number"

            # Make sure DB_POOL_MAX_ACTIVE > DB_POOL_MAX_IDLE
            [ ${DB_POOL_MAX_ACTIVE} -gt ${DB_POOL_MAX_IDLE} ] || errorExit "DB_POOL_MAX_ACTIVE (${DB_POOL_MAX_ACTIVE}) must be higher than DB_POOL_MAX_IDLE (${DB_POOL_MAX_IDLE})"

            logger "Setting pool.max.idle=${DB_POOL_MAX_IDLE}"
        else
            logger "DB_POOL_MAX_IDLE not set. Setting pool.max.idle to 1/10 of pool.max.active"

            DB_POOL_MAX_IDLE=$(( ${DB_POOL_MAX_ACTIVE} / 10 ))
            logger "Setting pool.max.idle=${DB_POOL_MAX_IDLE}"
        fi

        # Just in case file already has the property
        grep pool.max.idle ${DB_PROPS} > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            sed -i "s,pool.max.idle=.*,pool.max.idle=${DB_POOL_MAX_IDLE},g" ${DB_PROPS} || errorExit "Updating pool.max.idle=${DB_POOL_MAX_IDLE} in ${DB_PROPS} failed"
        else
            echo "pool.max.idle=${DB_POOL_MAX_IDLE}" >> ${DB_PROPS} || errorExit "Writing pool.max.idle=${DB_POOL_MAX_IDLE} to ${DB_PROPS} failed"
        fi
    else
        logger "Not needed. DB_POOL_MAX_ACTIVE not set"
    fi
}

# Check DB type configurations before starting Artifactory
setDBConf () {
    # Set DB_HOST
    if [ -z "$DB_HOST" ]; then
        DB_HOST=$DB_TYPE
    fi
    logger "DB_HOST is set to $DB_HOST"

    logger "Checking if need to copy $DB_TYPE configuration"
    # If already exists, just make sure it's configured for postgres
    if [ -f ${DB_PROPS} ]; then
        logger "${DB_PROPS} already exists. Making sure it's set to $DB_TYPE... "
        grep type=$DB_TYPE ${DB_PROPS} > /dev/null
        if [ $? -eq 0 ]; then
            logger "${DB_PROPS} already set to $DB_TYPE"
        else
            errorExit "${DB_PROPS} already exists and is set to a DB different than $DB_TYPE"
        fi
    else
        NEED_COPY=true
    fi

    # On a new install and startup, need to make the initial copy before Artifactory starts
    if [ "$NEED_COPY" == "true" ]; then
        logger "Copying $DB_TYPE configuration... "
        cp ${ARTIFACTORY_HOME}/misc/db/$DB_TYPE.properties ${DB_PROPS} || errorExit "Copying $ARTIFACTORY_HOME/misc/db/$DB_TYPE.properties to ${DB_PROPS} failed"

        sed -i "s/localhost/$DB_HOST/g" ${DB_PROPS}

        # Set custom DB parameters if specified
        if [ ! -z "$DB_URL" ]; then
            logger "Setting DB_URL to $DB_URL"
            sed -i "s|url=.*|url=$DB_URL|g" ${DB_PROPS}
        fi
        if [ ! -z "$DB_USER" ]; then
            logger "Setting DB_USER to $DB_USER"
            sed -i "s/username=.*/username=$DB_USER/g" ${DB_PROPS}
        fi
        if [ ! -z "$DB_PASSWORD" ]; then
            logger "Setting DB_PASSWORD to **********"
            sed -i "s/password=.*/password=$DB_PASSWORD/g" ${DB_PROPS}
        fi
        if [ ! -z "$DB_PORT" ]; then
            logger "Setting DB_PORT to $DB_PORT"
            case "$DB_TYPE" in
            mysql|postgresql|mariadb)
                oldPort=$(grep -E "(url).*" ${DB_PROPS}  | awk -F":" '{print $4}' | awk -F"/" '{print $1}')
            ;;
            oracle)
                oldPort=$(grep -E "(url).*" ${DB_PROPS} | awk -F":" '{print $5}')
            ;;
            mssql)
                oldPort=$(grep -E "(url).*" ${DB_PROPS}  | awk -F":" '{print $4}' | awk -F";" '{print $1}')
            ;;
            esac
            sed -i "s/$oldPort/$DB_PORT/g" ${DB_PROPS}
        fi
        if [ ! -z "$DB_HOST" ]; then
            logger "Setting DB_HOST to $DB_HOST"
            case "$DB_TYPE" in
            mysql|postgresql|mssql|mariadb)
                oldHost=$(grep -E "(url).*" ${DB_PROPS} | awk -F"//" '{print $2}' | awk -F":" '{print $1}')
            ;;
            oracle)
                oldHost=$(grep -E "(url).*" ${DB_PROPS} | awk -F"@" '{print $2}' | awk -F":" '{print $1}')
            ;;
            esac
            sed -i "s/$oldHost/$DB_HOST/g" ${DB_PROPS}
        fi
    fi
}

# Set and configure DB type
setDBType () {
    logger "Checking DB_TYPE"
    if [ -f "${ART_ETC}/.secrets/.temp.db.properties" ]
    then
        SECRET_DB_PROPS_FILE="${ART_ETC}/.secrets/.temp.db.properties"
        logger "Detected secret db.properties file at ${SECRET_DB_PROPS_FILE}. Secret file will override default db.properties file as well as environment variables."
        DB_TYPE_FROM_SECRET=$(grep -E "(type).*" "$SECRET_DB_PROPS_FILE" | awk -F"=" '{ print $2 }')
        if [[ "$DB_TYPE_FROM_SECRET" =~ ^(postgresql|mysql|oracle|mssql|mariadb)$ ]]; then DB_TYPE=${DB_TYPE_FROM_SECRET} ; fi
    fi
    if [ ! -z "${DB_TYPE}" ] && [ "${DB_TYPE}" != derby ]; then
        logger "DB_TYPE is set to $DB_TYPE"
        NEED_COPY=false
        DB_PROPS=${ART_ETC}/db.properties
        if [ ! -z "$SECRET_DB_PROPS_FILE" ]
        then
            DB_PROPS=${SECRET_DB_PROPS_FILE}
            logger "DB_PROPS set to: ${DB_PROPS}"
        fi

        setDBConf

        # Wait for DB
        # On slow systems, when working with docker-compose, the DB container might be up,
        # but not ready to accept connections when Artifactory is already trying to access it.
        if [[ ! "$HA_IS_PRIMARY" =~ false ]]; then
            waitForDB "$DB_PROPS" "$DB_TYPE"
            [ $? -eq 1 ] || errorExit "DB $DB_TYPE failed to start in the given time"
        fi
    fi
    if [ -z "${DB_TYPE}" ] || [ "${DB_TYPE}" == derby ]; then
        logger "Artifactory will use embedded Derby DB"
        # In case db.properties is missing, create a Derby default db.properties
        if [ ! -f ${DB_PROPS} ]; then
            logger "${DB_PROPS} does not exist. Creating it with defaults"
            cat << DB_P > "${DB_PROPS}"
# File auto generated by Docker entrypoint
type=derby
url=jdbc:derby:{db.home};create=true
driver=org.apache.derby.jdbc.EmbeddedDriver
DB_P
        fi
    fi

    setMaxDBConnections
}

addExtraJavaArgs () {
    logger "Adding EXTRA_JAVA_OPTIONS if exist"
    if [ ! -z "${EXTRA_JAVA_OPTIONS}" ] && [ ! -f ${ARTIFACTORY_HOME}/bin/artifactory.default.origin ]; then
        logger "Adding EXTRA_JAVA_OPTIONS ${EXTRA_JAVA_OPTIONS}"
        cp -v ${ARTIFACTORY_HOME}/bin/artifactory.default ${ARTIFACTORY_HOME}/bin/artifactory.default.origin || errorExit "Copy ${ARTIFACTORY_HOME}/bin/artifactory.default to ${ARTIFACTORY_HOME}/bin/artifactory.default.origin failed"
        echo "export JAVA_OPTIONS=\"\$JAVA_OPTIONS ${EXTRA_JAVA_OPTIONS}\"" >> ${ARTIFACTORY_HOME}/bin/artifactory.default || errorExit "Update ${ARTIFACTORY_HOME}/bin/artifactory.default failed"
    fi
}
copyExtraConf () {
    logger "Copying from artifactory_extra_conf"
    chown ${ARTIFACTORY_USER_NAME}:${ARTIFACTORY_USER_NAME} /bootstrap/*
    cp -pv /bootstrap/* ${ARTIFACTORY_HOME}/etc/
}

terminate () {
    echo -e "\nTerminating Artifactory"
    ${ARTIFACTORY_HOME}/bin/artifactory.sh stop
}

# Catch Ctrl+C and other termination signals to try graceful shutdown
trap terminate SIGINT SIGTERM SIGHUP

logger "Preparing to run Artifactory in Docker"
logger "Running as $(id)"

printDockerFileLocation
checkULimits
setupDataDirs
# CUSTOM:START - do this after setupDataDirs and setupArtUser so we can chown and copy our files.
copyExtraConf
# CUSTOM:END
setAccessCreds
setMasterKey
setDBType
configureServerXml
addExtraJavaArgs

logger "Setup done. Running Artifactory"

# Run Artifactory as ARTIFACTORY_USER_NAME user
exec ${ARTIFACTORY_HOME}/bin/artifactory.sh &
art_pid=$!

echo ${art_pid} > ${ARTIFACTORY_PID}

wait ${art_pid}