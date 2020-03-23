-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reg_device_sub_type
-- Purpose    	: Device Sub Type : Sub types of devices that are supported by the MOSIP system,  like  Slab, Single, Touchless...etc
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 04-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.reg_device_sub_type | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_device_sub_type CASCADE;
CREATE TABLE master.reg_device_sub_type(
	code character varying(36) NOT NULL,
	dtyp_code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(512),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rdstyp_code PRIMARY KEY (code),
	CONSTRAINT uk_rdstyp UNIQUE (dtyp_code,name)

);
-- ddl-end --
COMMENT ON TABLE master.reg_device_sub_type IS 'Device Sub Type : Sub types of devices that are supported by the MOSIP system,  like  Slab, Single, Touchless...etc';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.code IS 'Device Sub Type Code: Sub types of devices used for registration processes, authentication...etc for ex., SLB, SINGLE, FULLFACE... etc';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.dtyp_code IS 'Device Type Code : Code of the device type where this sub type belongs to. refers to master.reg_device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.name IS 'Device Name: Name of the device sub type';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.descr IS 'Device description: Device sub type description';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.is_active IS 'IS_Active : Flag to mark whether the record/device is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_device_sub_type.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --