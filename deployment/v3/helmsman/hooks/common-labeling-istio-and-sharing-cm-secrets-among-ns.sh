#!/bin/bash
# Centralized Post-Install Setup Script for MOSIP Deployment

# Namespaces
declare -A NAMESPACES=(
    [KEYMGR]="keymanager"
    [WEBSUB]="websub"
    [SMTP]="mock-smtp"
    [KERNEL]="kernel"
    [MDL]="masterdata-loader"
    [BIOSDK]="biosdk"
    [PACKETMANAGER]="packetmanager"
    [DATASHARE]="datashare"
    [ABIS]="abis"
    [DC]="digitalcard"
    [ADMIN]="admin"
    [PREREG]="prereg"
    [IDA]="ida"
    [IDREPO]="idrepo"
    [MFS]="mosip-file-server"
    [PMS]="pms"
    [PRINT]="print"
    [REGPROC]="regproc"
    [REGCLIENT]="regclient"
)

# Define namespaces with istio injection enabled or disabled
ISTIO_ENABLED_NS=(
    "KEYMGR" "WEBSUB" "SMTP" "KERNEL" "DC" "BIOSDK" 
    "PACKETMANAGER" "DATASHARE" "ABIS" "ADMIN" "IDA" 
    "IDREPO" "PMS" "PRINT" "REGPROC" "REGCLIENT"
)
ISTIO_DISABLED_NS=("PREREG")

# Define configmaps to copy
# Format: "config_map_name:source_namespace"
COMMON_CONFIGMAPS=(
    "global:default"
    "artifactory-share:artifactory"
    "config-server-share:config-server"
)

# Special configmaps for specific namespaces
SPECIAL_CONFIGMAPS=(
    "softhsm-kernel-share:softhsm:KEYMGR"
    "softhsm-ida-share:softhsm:IDA"
)

# Namespace-specific configmaps that only get certain configmaps
# Format: "namespace_key:configmap_name:source_namespace"
NAMESPACE_SPECIFIC_CONFIGMAPS=(
    "REGCLIENT:artifactory-share:artifactory"
)

# Copy utility script path
COPY_UTIL="$WORKDIR/utils/copy-cm-and-secrets/copy_cm_func.sh"

function installing_all() {
    echo "Applying Istio labels..."
    
    # Apply Istio labels for enabled namespaces
    for ns_key in "${ISTIO_ENABLED_NS[@]}"; do
        kubectl label ns "${NAMESPACES[$ns_key]}" istio-injection=enabled --overwrite
    done
    
    # Apply Istio labels for disabled namespaces
    for ns_key in "${ISTIO_DISABLED_NS[@]}"; do
        kubectl label ns "${NAMESPACES[$ns_key]}" istio-injection=disabled --overwrite
    done

    echo "Applying additional configurations..."
    # Apply additional configurations
    kubectl apply -n ${NAMESPACES[KEYMGR]} -f $WORKDIR/utils/idle_timeout_envoyfilter.yaml
    
    echo "Installing Admin-Proxy into Masterdata and Keymanager."
    kubectl -n ${NAMESPACES[ADMIN]} apply -f $WORKDIR/utils/admin-proxy.yaml
    
    echo "Installing prereg rate-control Envoyfilter"
    kubectl apply -n ${NAMESPACES[PREREG]} -f $WORKDIR/utils/rate-control-envoyfilter.yaml
    
    # Commented lines from original script (kept for reference)
    #kubectl -n ${NAMESPACES[MFS]} --ignore-not-found=true delete configmap mosip-file-server
    #kubectl -n ${NAMESPACES[MFS]} --ignore-not-found=true delete secret keycloak-client-secret

    echo "Copying Resources..."
    
    # SMTP special case (preserving the exact syntax from original)
    $COPY_UTIL "configmap" "global" "default" "${NAMESPACES[SMTP]}"
    
    # Copy common configmaps to all namespaces (except source namespaces and special cases)
    for ns_key in "${!NAMESPACES[@]}"; do
        # Skip MFS and REGCLIENT as they have special handling
        if [[ "$ns_key" == "MFS" || "$ns_key" == "REGCLIENT" ]]; then
            continue
        fi
        
        # Copy common configmaps
        for cm_entry in "${COMMON_CONFIGMAPS[@]}"; do
            IFS=':' read -r cm_name src_ns <<< "$cm_entry"
            
            # Skip if target namespace is the same as source namespace
            [[ "${NAMESPACES[$ns_key]}" == "$src_ns" ]] && continue
            
            $COPY_UTIL configmap "$cm_name" "$src_ns" "${NAMESPACES[$ns_key]}"
        done
    done
    
    # Copy special configmaps
    for special_cm in "${SPECIAL_CONFIGMAPS[@]}"; do
        IFS=':' read -r cm_name src_ns target_ns_key <<< "$special_cm"
        $COPY_UTIL configmap "$cm_name" "$src_ns" "${NAMESPACES[$target_ns_key]}"
    done
    
    # Handle namespace-specific configmaps
    for specific_cm in "${NAMESPACE_SPECIFIC_CONFIGMAPS[@]}"; do
        IFS=':' read -r target_ns_key cm_name src_ns <<< "$specific_cm"
        echo "Copying configmap $cm_name from $src_ns to ${NAMESPACES[$target_ns_key]}"
        $COPY_UTIL configmap "$cm_name" "$src_ns" "${NAMESPACES[$target_ns_key]}"
    done
    
    # Special case for MFS (only needs config-server-share)
    $COPY_UTIL configmap config-server-share config-server ${NAMESPACES[MFS]}
    
    # Copy secrets
    $COPY_UTIL secret db-common-secrets postgres ${NAMESPACES[MDL]}
    
    return 0
}

# Set error handling exactly as in the original script
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes

# Call the function just like in the original script
installing_all