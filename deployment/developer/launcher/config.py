# This file contains the config parameters of the launcher. Inspect the file
# carefully before running the launcher.  Esp. MOSIP_DIR.
# Ports:
# Kernel Auth Service: 8191
# Kernel Keymanager Service: 8188
# Registration Process Status Service: 8013
# Audit Manager: 8181
# Signature Service: 8192
# Cryptomanager Service: 8187
# Masterdata Service: 8186
# Reg Proc Sync Service: 8083
# Reg Proc Packet Receiver Service: 8081
# Reg Proc Packet Uploader Service: 8087

import os

MOSIP_DIR = os.path.join(os.environ['HOME'], 'mosip')
MOSIP_VERSION = '0.10.0'  # Such a tag should exist on the repo
MOSIP_REPO = 'https://github.com/mosip/mosip-platform'

SOFTHSM_INSTALL_DIR = MOSIP_DIR
SOFTHSM_CONFIG_DIR = os.path.join(os.environ['HOME'], '.softhsm')
SOFTHSM_PIN = '1234'

CODE_DIR = os.path.join(MOSIP_DIR, 'mosip-platform')

# Directory for landing zone and archival. Should be same as in 
# registration-processor.properties
PACKET_STORE = os.path.join(MOSIP_DIR, 'packet_store') 
PACKET_LANDING = os.path.join(PACKET_STORE, 'LANDING_ZONE')
PACKET_ARCHIVAL = os.path.join(PACKET_STORE, 'ARCHIVE_PACKET_LOCATION') 

POSTGRES_PORT = 5432
PG_CONF_DIR = '/var/lib/pgsql/10/data'  # Postgres

SFTP_KEY = 'sftpkey' # Should be same as in registration-processor.properties
CONFIG_SERVER_PORT = 8888 # Should be same as in application.properties of 
                          # config-server
COUNTRY_NAME='mycountry'  # For LDAP 

LDAP_PORT = 10389
CLAMAV_PORT = 3310 # CAUTION: Change resources/clamav_scan.conf if you change this

# Local repo where all config files of MOSIP will be fetched by config server.
CONFIG_REPO= os.path.join(MOSIP_DIR, 'myconfig')  # git repo 
LOGS_DIR = os.path.join(MOSIP_DIR, 'logs')

JAVA_HEAP_SIZE = '256m' 

PACKET_LANDING_ZONE_PATH = os.path.join(MOSIP_DIR, 'dmz_packet_store') 
DB_SCRIPTS_PATH = os.path.join(MOSIP_DIR, 'mosip-platform/db_scripts/')
DB_PASSWORDS = { # Same passwords should be present in .properties files
    'sysadminpwd' : 'Mosipadm@dev123',
    'dbadminpwd' : 'Mosipadm@dev123', 
    'appadminpwd': 'Mosipadm@dev123', 
    'dbuserpwd' : 'Mosip@dev123'
}
# dict:  {dbname : list of sql corresponding sql files}
DB_DICT =  {  # These are in a paritcular sequence
    'mosip_kernel' : [ 
        'mosip_kernel/mosip_role_common.sql',
        'mosip_kernel/mosip_role_kerneluser.sql',
        'mosip_kernel/mosip_kernel_db.sql',
        'mosip_kernel/mosip_kernel_grants.sql',
        'mosip_kernel/mosip_kernel_ddl_deploy.sql',
        'mosip_kernel/mosip_kernel_dml_deploy.sql',
    ],
    'mosip_audit' : [
        'mosip_audit/mosip_role_common.sql',
        'mosip_audit/mosip_role_audituser.sql',
        'mosip_audit/mosip_audit_db.sql',
        'mosip_audit/mosip_audit_grants.sql',
        'mosip_audit/mosip_audit_ddl_deploy.sql',
    ], 
    'mosip_iam' : [
        'mosip_iam/mosip_role_common.sql',
        'mosip_iam/mosip_role_iamuser.sql',
        'mosip_iam/mosip_iam_db.sql',
        'mosip_iam/mosip_iam_grants.sql',
        'mosip_iam/mosip_iam_ddl_deploy.sql',
        'mosip_iam/mosip_iam_dml_deploy.sql',
    ], 
    'mosip_ida' : [
        'mosip_ida/mosip_role_common.sql',
        'mosip_ida/mosip_role_idauser.sql',
        'mosip_ida/mosip_ida_db.sql',
        'mosip_ida/mosip_ida_grants.sql',
        'mosip_ida/mosip_ida_ddl_deploy.sql',
    ], 
    'mosip_idmap' : [
        'mosip_idmap/mosip_role_common.sql',
        'mosip_idmap/mosip_role_idmapuser.sql',
        'mosip_idmap/mosip_idmap_db.sql',
        'mosip_idmap/mosip_idmap_grants.sql',
        'mosip_idmap/mosip_idmap_ddl_deploy.sql',
    ], 
    'mosip_idrepo' : [
        'mosip_idrepo/mosip_role_common.sql',
        'mosip_idrepo/mosip_role_idrepouser.sql',
        'mosip_idrepo/mosip_idrepo_db.sql',
        'mosip_idrepo/mosip_idrepo_grants.sql',
        'mosip_idrepo/mosip_idrepo_ddl_deploy.sql',
    ], 
    'mosip_master' : [
        'mosip_master/mosip_role_common.sql',
        'mosip_master/mosip_role_masteruser.sql',
        'mosip_master/mosip_master_db.sql',
        'mosip_master/mosip_master_grants.sql',
        'mosip_master/mosip_master_ddl_deploy.sql',
        'mosip_master/mosip_master_dml_deploy.sql',
    ], 
    'mosip_pmp' : [
        'mosip_pmp/mosip_role_common.sql',
        'mosip_pmp/mosip_role_pmpuser.sql',
        'mosip_pmp/mosip_pmp_db.sql',
        'mosip_pmp/mosip_pmp_grants.sql',
        'mosip_pmp/mosip_pmp_ddl_deploy.sql',
    ], 
    'mosip_prereg': [
        'mosip_prereg/mosip_role_common.sql',
        'mosip_prereg/mosip_role_prereguser.sql',
        'mosip_prereg/mosip_prereg_db.sql',
        'mosip_prereg/mosip_prereg_grants.sql',
        'mosip_prereg/mosip_prereg_ddl_deploy.sql',
        'mosip_prereg/mosip_prereg_dml_deploy.sql',
    ],
    'mosip_regprc': [
        'mosip_regprc/mosip_role_common.sql',
        'mosip_regprc/mosip_role_regprcuser.sql',
        'mosip_regprc/mosip_regprc_db.sql',
        'mosip_regprc/mosip_regprc_grants.sql',
        'mosip_regprc/mosip_regprc_ddl_deploy.sql',
        'mosip_regprc/mosip_regprc_dml_deploy.sql' 
    ]
}

SQL_SCRIPTS = [  # These are in a paritcular sequence
    'mosip_kernel/mosip_role_common.sql',
    'mosip_kernel/mosip_role_kerneluser.sql',
    'mosip_kernel/mosip_kernel_db.sql',
    'mosip_kernel/mosip_kernel_grants.sql',
    'mosip_kernel/mosip_kernel_ddl_deploy.sql',
    'mosip_kernel/mosip_kernel_dml_deploy.sql',

    'mosip_audit/mosip_role_common.sql',
    'mosip_audit/mosip_role_audituser.sql',
    'mosip_audit/mosip_audit_db.sql',
    'mosip_audit/mosip_audit_grants.sql',
    'mosip_audit/mosip_audit_ddl_deploy.sql',

    'mosip_iam/mosip_role_common.sql',
    'mosip_iam/mosip_role_iamuser.sql',
    'mosip_iam/mosip_iam_db.sql',
    'mosip_iam/mosip_iam_grants.sql',
    'mosip_iam/mosip_iam_ddl_deploy.sql',
    'mosip_iam/mosip_iam_dml_deploy.sql',

    'mosip_ida/mosip_role_common.sql',
    'mosip_ida/mosip_role_idauser.sql',
    'mosip_ida/mosip_ida_db.sql',
    'mosip_ida/mosip_ida_grants.sql',
    'mosip_ida/mosip_ida_ddl_deploy.sql',

    'mosip_idmap/mosip_role_common.sql',
    'mosip_idmap/mosip_role_idmapuser.sql',
    'mosip_idmap/mosip_idmap_db.sql',
    'mosip_idmap/mosip_idmap_grants.sql',
    'mosip_idmap/mosip_idmap_ddl_deploy.sql',

    'mosip_idrepo/mosip_role_common.sql',
    'mosip_idrepo/mosip_role_idrepouser.sql',
    'mosip_idrepo/mosip_idrepo_db.sql',
    'mosip_idrepo/mosip_idrepo_grants.sql',
    'mosip_idrepo/mosip_idrepo_ddl_deploy.sql',

    'mosip_master/mosip_role_common.sql',
    'mosip_master/mosip_role_masteruser.sql',
    'mosip_master/mosip_master_db.sql',
    'mosip_master/mosip_master_grants.sql',
    'mosip_master/mosip_master_ddl_deploy.sql',
    'mosip_master/mosip_master_dml_deploy.sql',
  
    'mosip_pmp/mosip_role_common.sql',
    'mosip_pmp/mosip_role_pmpuser.sql',
    'mosip_pmp/mosip_pmp_db.sql',
    'mosip_pmp/mosip_pmp_grants.sql',
    'mosip_pmp/mosip_pmp_ddl_deploy.sql',

    'mosip_prereg/mosip_role_common.sql',
    'mosip_prereg/mosip_role_prereguser.sql',
    'mosip_prereg/mosip_prereg_db.sql',
    'mosip_prereg/mosip_prereg_grants.sql',
    'mosip_prereg/mosip_prereg_ddl_deploy.sql',
    'mosip_prereg/mosip_prereg_dml_deploy.sql',

    'mosip_regprc/mosip_role_common.sql',
    'mosip_regprc/mosip_role_regprcuser.sql',
    'mosip_regprc/mosip_regprc_db.sql',
    'mosip_regprc/mosip_regprc_grants.sql',
    'mosip_regprc/mosip_regprc_ddl_deploy.sql',
    'mosip_regprc/mosip_regprc_dml_deploy.sql' 
]

# (module, service, additional run options, log file suffix)
PREREG_SERVICES = [
    ('preregistration', 'pre-registration-login-service', '', ''),
    ('preregistration', 'pre-registration-notification-service', '', ''),
    ('preregistration', 'pre-registration-demographic-service', '', '')]

REGPROC_SERVICES = [
    ('registrationprocessor', 'registration-processor-packet-receiver-stage', '', ''),
    ('registrationprocessor', 'registration-processor-packet-uploader-stage', '-Dregistration.processor.zone=secure', ''),
    ('registrationprocessor', 'registration-processor-packet-validator-stage', '', ''), 
    ('registrationprocessor', 'registration-processor-quality-checker-stage', '', ''), 
    ('registrationprocessor', 'registration-processor-osi-validator-stage', '', ''),
    ('registrationprocessor', 'registration-processor-common-camel-bridge', '-Dregistration.processor.zone=dmz -Deventbus.port=5722', '_dmz'),
    ('registrationprocessor', 'registration-processor-common-camel-bridge', '-Dregistration.processor.zone=secure -Deventbus.port=5723', '_secure'),
    ('registrationprocessor', 'registration-processor-registration-status-service', '', '')
]

KERNEL_SERVICES = [ 
    ('kernel', 'kernel-auth-service', '-Dserver.port=8191', ''),
    ('kernel', 'kernel-keymanager-service', '-Dserver.port=8188', ''),
    #('kernel', 'kernel-otpmanager-service', '-Dserver.port=8185', ''),
    #('kernel', 'kernel-emailnotification-service', '-Dserver.port=8183', ''),
    ('kernel', 'kernel-masterdata-service', '-Dserver.port=8186', ''),
    ('kernel', 'kernel-syncdata-service', '-Dserver.port=8189', ''),
    ('kernel', 'kernel-cryptomanager-service', '-Dserver.port=8187', ''),
    ('kernel', 'kernel-signature-service', '-Dserver.port=8192', ''),
    ('kernel', 'kernel-auditmanager-service', '-Dserver.port=8181', ''),
]

MOSIP_SERVICES = KERNEL_SERVICES + REGPROC_SERVICES 

