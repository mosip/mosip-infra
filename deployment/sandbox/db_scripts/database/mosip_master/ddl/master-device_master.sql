-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.device_master
-- Purpose    	: Device Master : Contains list of approved devices and  details,  like fingerprint scanner, iris scanner, scanner etc used at registration centers. Valid devices with active status only allowed at registration centers for respective functionalities. Device onboarding are handled through admin application/portal by the user who is having the device onboarding authority.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.device_master | type: TABLE --
-- DROP TABLE IF EXISTS master.device_master CASCADE;
CREATE TABLE master.device_master(
	id 			character varying(36) NOT NULL,
	name 		character varying(64) NOT NULL,
	mac_address character varying(64) NOT NULL,
	serial_num 	character varying(64) NOT NULL,
	ip_address 	character varying(17),
	validity_end_dtimes timestamp,
	dspec_id 	character varying(36) NOT NULL,
	zone_code 	character varying(36) NOT NULL,
	lang_code 	character varying(3) NOT NULL,
	is_active 	boolean NOT NULL,
	cr_by 		character varying(256) NOT NULL,
	cr_dtimes 	timestamp NOT NULL,
	upd_by 		character varying(256),
	upd_dtimes 	timestamp,
	is_deleted 	boolean,
	del_dtimes 	timestamp,
	CONSTRAINT pk_devicem_id PRIMARY KEY (id,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.device_master IS 'Device Master : Contains list of approved devices and  details,  like fingerprint scanner, iris scanner, scanner etc used at registration centers. Valid devices with active status only allowed at registration centers for respective functionalities. Device onboarding are handled through admin application/portal by the user who is having the device onboarding authority. ';
-- ddl-end --
COMMENT ON COLUMN master.device_master.id IS 'Device ID : Unique ID generated / assigned for device';
-- ddl-end --
COMMENT ON COLUMN master.device_master.name IS 'Name : Device name';
-- ddl-end --
COMMENT ON COLUMN master.device_master.mac_address IS 'Mac Address: Mac address of the device';
-- ddl-end --
COMMENT ON COLUMN master.device_master.serial_num IS 'Serial Number: Serial number of the device';
-- ddl-end --
COMMENT ON COLUMN master.device_master.ip_address IS 'IP Address: IP address of the device';
-- ddl-end --
COMMENT ON COLUMN master.device_master.validity_end_dtimes IS 'Validity End Datetime: Device validity expiry date';
-- ddl-end --
COMMENT ON COLUMN master.device_master.dspec_id IS 'Device Specification ID : Device specification id refers to master.device_spec.id';
-- ddl-end --
COMMENT ON COLUMN master.device_master.zone_code IS 'Zone Code : Unique zone code generated or entered by admin while creating zones, It is referred to master.zone.code. ';
-- ddl-end --
COMMENT ON COLUMN master.device_master.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.device_master.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.device_master.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.device_master.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.device_master.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.device_master.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.device_master.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.device_master.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
