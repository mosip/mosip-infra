-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.device_spec
-- Purpose    	: Device Specification :  Specification of devices for each device type that are supported by system for various process requirements, like scanning, printing, photo, biometric etc.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.device_spec | type: TABLE --
-- DROP TABLE IF EXISTS master.device_spec CASCADE;
CREATE TABLE master.device_spec(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	brand character varying(32) NOT NULL,
	model character varying(16) NOT NULL,
	dtyp_code character varying(36) NOT NULL,
	min_driver_ver character varying(16) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_dspec_code PRIMARY KEY (id,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.device_spec IS 'Device Specification :  Specification of devices for each device type that are supported by system for various process requirements, like scanning, printing, photo, biometric etc';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.id IS 'Device Specification ID : Unique ID generated / assigned for device specification';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.name IS 'Name : Device  short description/name';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.brand IS 'Device brand :  Manufacturer brand name of the devices supported';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.model IS 'Model: Model name of the device supported';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.dtyp_code IS 'Device Type Code: Device type code refers to master.device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.min_driver_ver IS 'Minimum Driver Version: Minimum supported version number of the device driver';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.descr IS 'Description : Device specification description';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.device_spec.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

