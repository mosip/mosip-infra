-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reg_center_machine_device
-- Purpose    	: Registration Center Machine Device : Mapping table to assign machines and devices that are used at a registration center.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.reg_center_machine_device | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_center_machine_device CASCADE;
CREATE TABLE master.reg_center_machine_device(
	regcntr_id character varying(10) NOT NULL,
	machine_id character varying(10) NOT NULL,
	device_id character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_cntrmdev_regcntr_id PRIMARY KEY (regcntr_id,machine_id,device_id)

);
-- ddl-end --
COMMENT ON TABLE master.reg_center_machine_device IS 'Registration Center Machine Device : Mapping table to assign machines and devices that are used at a registration center';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.regcntr_id IS 'Registration Center ID : registration center id refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.machine_id IS 'Machine ID : Machine id refers to master.machine_master.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.device_id IS 'Device ID : Device id refers to master.device_master.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_machine_device.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
