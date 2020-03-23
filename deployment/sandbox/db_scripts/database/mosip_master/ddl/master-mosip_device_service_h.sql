-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.mosip_device_service_h
-- Purpose    	: MOSIP Device Service History : History of changes of any MOSIP device service will be stored in history table to track any chnages for future validations.
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 04-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.mosip_device_service_h | type: TABLE --
-- DROP TABLE IF EXISTS master.mosip_device_service_h CASCADE;
CREATE TABLE master.mosip_device_service_h(
	id character varying(36) NOT NULL,
	sw_binary_hash bytea NOT NULL,
	sw_version character varying(64),
	dprovider_id character varying(36) NOT NULL,
	dtype_code character varying(36) NOT NULL,
	dstype_code character varying(36) NOT NULL,
	make character varying(36),
	model character varying(36),
	sw_cr_dtimes timestamp,
	sw_expiry_dtimes timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	eff_dtimes timestamp NOT NULL,
	CONSTRAINT pk_mdsh_id PRIMARY KEY (id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE master.mosip_device_service_h IS 'MOSIP Device Service History : History of changes of any MOSIP device service will be stored in history table to track any chnages for future validations.';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.id IS 'ID: Unigue service ID, Service ID is geerated by the MOSIP system';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.sw_binary_hash IS 'Software Binary Hash : Its is a software binary stored in MOSIP system for the devices';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.sw_version IS 'Software Version : Version of the stored software';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.dprovider_id IS 'Device Provider ID : Device provider ID, Referenced from master.device_provider.id';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.dtype_code IS 'Device Type Code: Code of the device type, Referenced from master.reg_device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.dstype_code IS ' Device Sub Type Code: Code of the device sub type, Referenced from master.reg_device_sub_type.code';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.make IS 'Make: Make of the device';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.model IS ' Model: Model of the device';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.sw_cr_dtimes IS 'Software Created Date Time: Date and Time on which this software is created';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.sw_expiry_dtimes IS 'Software Expiry Date Time: Expiry date and time of the device software';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.is_active IS 'IS_Active : Flag to mark whether the record/device is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time.';
-- ddl-end --