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
MOSIP_VERSION = '1.1.5.5'  # Such a tag should exist on the repo
MOSIP_REPO = 'https://github.com/mosip/commons'

SOFTHSM_INSTALL_DIR = MOSIP_DIR
SOFTHSM_CONFIG_DIR = os.path.join(os.environ['HOME'], '.softhsm')
SOFTHSM_PIN = '1234'

CODE_DIR = os.path.join(MOSIP_DIR, 'mosip-platform')

PREREG_CODE_DIR = os.path.join(MOSIP_DIR, 'pre-registration/pre-registration')

# Directory for landing zone and archival. Should be same as in
# registration-processor.properties
PACKET_STORE = os.path.join(MOSIP_DIR, 'packet_store')
PACKET_LANDING = os.path.join(PACKET_STORE, 'LANDING_ZONE')
PACKET_ARCHIVAL = os.path.join(PACKET_STORE, 'ARCHIVE_PACKET_LOCATION')

POSTGRES_PORT = 5432
PG_CONF_DIR = '/var/lib/pgsql/10/data'  # Postgres

SFTP_KEY = 'sftpkey'  # Should be same as in registration-processor.properties
CONFIG_SERVER_PORT = 6616  # Should be same as in application.properties of
# config-server
COUNTRY_NAME = 'mycountry'  # For LDAP

CLAMAV_PORT = 3310  # CAUTION: Change resources/clamav_scan.conf if you change this

# Local repo where all config files of MOSIP will be fetched by config server.
CONFIG_REPO = os.path.join(MOSIP_DIR, 'myconfig')  # git repo
LOGS_DIR = os.path.join(
    MOSIP_DIR, 'mosip-infra/deployment/developer/launcher/logs')

JAVA_HEAP_SIZE = '256m'

PACKET_LANDING_ZONE_PATH = os.path.join(MOSIP_DIR, 'dmz_packet_store')
DB_SCRIPTS_PATH = os.path.join(MOSIP_DIR, 'mosip-platform/db_scripts/')
DB_PASSWORDS = {  # Same passwords should be present in .properties files
    'sysadminpwd': 'Mosipadm@dev123',
    'dbadminpwd': 'Mosipadm@dev123',
    'appadminpwd': 'Mosipadm@dev123',
    'dbuserpwd': 'Mosip@dev123'
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

    # 'mosip_ida/mosip_role_common.sql',
    # 'mosip_ida/mosip_role_idauser.sql',
    # 'mosip_ida/mosip_ida_db.sql',
    # 'mosip_ida/mosip_ida_grants.sql',
    # 'mosip_ida/mosip_ida_ddl_deploy.sql',

    # 'mosip_idmap/mosip_role_common.sql',
    # 'mosip_idmap/mosip_role_idmapuser.sql',
    # 'mosip_idmap/mosip_idmap_db.sql',
    # 'mosip_idmap/mosip_idmap_grants.sql',
    # 'mosip_idmap/mosip_idmap_ddl_deploy.sql',

    # 'mosip_idrepo/mosip_role_common.sql',
    # 'mosip_idrepo/mosip_role_idrepouser.sql',
    # 'mosip_idrepo/mosip_idrepo_db.sql',
    # 'mosip_idrepo/mosip_idrepo_grants.sql',
    # 'mosip_idrepo/mosip_idrepo_ddl_deploy.sql',

    'mosip_master/mosip_role_common.sql',
    'mosip_master/mosip_role_masteruser.sql',
    'mosip_master/mosip_master_db.sql',
    'mosip_master/mosip_master_grants.sql',
    'mosip_master/mosip_master_ddl_deploy.sql',
    'mosip_master/mosip_master_dml_deploy.sql',

    # 'mosip_pmp/mosip_role_common.sql',
    # 'mosip_pmp/mosip_role_pmpuser.sql',
    # 'mosip_pmp/mosip_pmp_db.sql',
    # 'mosip_pmp/mosip_pmp_grants.sql',
    # 'mosip_pmp/mosip_pmp_ddl_deploy.sql',

    # 'mosip_prereg/mosip_role_common.sql',
    # 'mosip_prereg/mosip_role_prereguser.sql',
    # 'mosip_prereg/mosip_prereg_db.sql',
    # 'mosip_prereg/mosip_prereg_grants.sql',
    # 'mosip_prereg/mosip_prereg_ddl_deploy.sql',
    # 'mosip_prereg/mosip_prereg_dml_deploy.sql',

    # 'mosip_regprc/mosip_role_common.sql',
    # 'mosip_regprc/mosip_role_regprcuser.sql',
    # 'mosip_regprc/mosip_regprc_db.sql',
    # 'mosip_regprc/mosip_regprc_grants.sql',
    # 'mosip_regprc/mosip_regprc_ddl_deploy.sql',
    # 'mosip_regprc/mosip_regprc_dml_deploy.sql'
]

# (module, service, additional run options, log file suffix)
PREREG_SERVICES = [
    ('preregistration', 'pre-registration-application-service', '', ''),
    ('preregistration', 'pre-registration-batchjob', '', ''),
    ('preregistration', 'pre-registration-captcha-service', '', ''),
    ('preregistration', 'pre-registration-core', '', ''),
    ('preregistration', 'pre-registration-datasync-service', '', '')]

# REGPROC_SERVICES = [
#     ('registrationprocessor', 'registration-processor-core', '', ''),
#     ('registrationprocessor', 'registration-processor-bio-dedupe-service-impl', '', ''),
#     ('registrationprocessor', 'registration-processor-notification-service', '', ''),
#     ('registrationprocessor', 'registration-processor-info-storage-service', '', ''),
#     ('registrationprocessor', 'registration-processor-message-sender-impl', '', ''),
#     ('registrationprocessor', 'registration-processor-common-camel-bridge', '-Dregistration.processor.zone=dmz -Deventbus.port=5722', '_dmz'),
#     ('registrationprocessor', 'registration-processor-common-camel-bridge', '-Dregistration.processor.zone=secure -Deventbus.port=5723', '_secure'),
#     ('registrationprocessor', 'registration-processor-packet-manager', '', '')

#      ('registrationprocessor', 'registration-processor-quality-checker', '', ''),
#       ('registrationprocessor', 'registration-processor-registration-status-service-impl', '', ''),
#        ('registrationprocessor', 'registration-processor-rest-client', '', '')

# ]

KERNEL_SERVICES = [
    ('kernel', 'kernel-auth-service', '-Dserver.port=8191', '',
     '1.1.5.5-SNAPSHOT/kernel-auth-service-1.1.5.5-SNAPSHOT.jar'),

    ('kernel', 'kernel-keymanager-service', '-Dserver.port=8188', '',
     '1.1.5.3/kernel-keymanager-service-1.1.5.3-lib.jar'),

    # ('kernel', 'kernel-otpmanager-service', '-Dserver.port=8185', '',
    # ''),
    #('kernel', 'kernel-emailnotification-service', '-Dserver.port=8183', ''),

    # ('kernel', 'kernel-masterdata-service', '-Dserver.port=8186', '',
    # ''),

    # ('kernel', 'kernel-syncdata-service', '-Dserver.port=8189', '',
    # ''),

    # ('kernel', 'kernel-cryptomanager-service', '-Dserver.port=8187', '',
    # ''),

    # ('kernel', 'kernel-signature-service', '-Dserver.port=8192', '',
    # ''),

    # ('kernel', 'kernel-auditmanager-service', '-Dserver.port=8181', '',
    # ''),

    # ('kernel', 'kernel-applicanttype-api', '-Dserver.port=5050', '',
    # ''),

    ('kernel', 'kernel-auditmanager-api', '-Dserver.port=5051', '',
    '1.1.5.5-SNAPSHOT/kernel-auditmanager-api-1.1.5.5-SNAPSHOT.jar'),

    ('kernel', 'kernel-auth-adapter', '-Dserver.port=5052', '',
    '1.1.5.5-SNAPSHOT/kernel-auth-adapter-1.1.5.5-SNAPSHOT.jar'),

    # ('kernel', 'kernel-authcodeflowproxy-api', '-Dserver.port=5053', '',
    # ''),

    # ('kernel', 'kernel-bioapi-provider', '-Dserver.port=5054', '',
    # ''),

    # ('kernel', 'kernel-biometrics-api', '-Dserver.port=5055', '',
    # ''),

    # ('kernel', 'kernel-biosdk-provider', '-Dserver.port=5056', '',
    # ''),

    # ('kernel', 'kernel-cbeffutil-api', '-Dserver.port=5057', '',
    # ''),

    ('kernel', 'kernel-core', '-Dserver.port=5058', '',
    '1.1.5.5-SNAPSHOT/kernel-core-1.1.5.5-SNAPSHOT.jar'),

    # ('kernel', 'kernel-crypto-jce', '-Dserver.port=5059', '',
    # ''),

    # ('kernel', 'kernel-crypto-signature', '-Dserver.port=5060', '',
    # ''),

    ('kernel', 'kernel-dataaccess-hibernate', '-Dserver.port=5061', '',
    '1.1.5.3/kernel-dataaccess-hibernate-1.1.5.3.jar'),

    # ('kernel', 'kernel-datamapper-orika', '-Dserver.port=5062', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-machineid', '-Dserver.port=5063', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-mispid', '-Dserver.port=5064', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-partnerid', '-Dserver.port=5065', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-prid', '-Dserver.port=5066', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-regcenterid', '-Dserver.port=5067', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-rid', '-Dserver.port=5068', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-service', '-Dserver.port=5069', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-tokenid', '-Dserver.port=5070', '',
    # ''),

    # ('kernel', 'kernel-idgenerator-vid', '-Dserver.port=5071', '',
    # ''),

    # ('kernel', 'kernel-idobjectvalidator', '-Dserver.port=5072', '',
    # ''),

    # ('kernel', 'kernel-idvalidator-mispid', '-Dserver.port=5073', '',
    # ''),

    # ('kernel', 'kernel-idvalidator-prid', '-Dserver.port=5074', '',
    # ''),

    # ('kernel', 'kernel-idvalidator-rid', '-Dserver.port=5075', '',
    # ''),

    # ('kernel', 'kernel-idvalidator-uin', '-Dserver.port=5076', '',
    # ''),

    # ('kernel', 'kernel-idvalidator-vid', '-Dserver.port=5077', '',
    # ''),

    # ('kernel', 'kernel-keygenerator-bouncycastle', '-Dserver.port=5078', '',
    # ''),

    # ('kernel', 'kernel-licensekeygenerator-misp', '-Dserver.port=5079', '',
    # ''),

    ('kernel', 'kernel-logger-logback', '-Dserver.port=5080', '',
    '1.1.5.3/kernel-logger-logback-1.1.5.3.jar'),

    # ('kernel', 'kernel-notification-service', '-Dserver.port=5081', '',
    # ''),

    ('kernel', 'kernel-pdfgenerator-itext', '-Dserver.port=5082', '',
    '1.1.5.3/kernel-pdfgenerator-itext-1.1.5.3.jar'),

    # ('kernel', 'kernel-pinvalidator', '-Dserver.port=5083', '',
    # ''),

    # ('kernel', 'kernel-pridgenerator-service', '-Dserver.port=5084', '',
    # ''),

    # ('kernel', 'kernel-qrcodegenerator-zxing', '-Dserver.port=5085', '',
    # ''),

    # ('kernel', 'kernel-registration-packet-manager', '-Dserver.port=5086', '',
    # ''),

    # ('kernel', 'kernel-ridgenerator-service', '-Dserver.port=5087', '',
    # ''),

    # ('kernel', 'kernel-salt-generator', '-Dserver.port=5088', '',
    # ''),

    ('kernel', 'kernel-templatemanager-velocity', '-Dserver.port=5089', '',
    '1.1.5.3/kernel-templatemanager-velocity-1.1.5.3.jar'),

    # ('kernel', 'kernel-transliteration-icu4j', '-Dserver.port=5090', '',
    # ''),
    
    ('kernel', 'kernel-websubclient-api', '-Dserver.port=5091', '',
    '1.1.5.5-SNAPSHOT/kernel-websubclient-api-1.1.5.5-SNAPSHOT.jar'),

    # ('kernel', 'keys-generator', '-Dserver.port=5092', '',
    # ''),

    # ('kernel', 'khazana', '-Dserver.port=5093', '',
    # '')

]

# MOSIP_SERVICES = KERNEL_SERVICES + REGPROC_SERVICES
MOSIP_SERVICES = KERNEL_SERVICES
