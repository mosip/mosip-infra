-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.mosip_device_service
-- Purpose    	: MOSIP Device Service : Mosip device cervice to have all the details about the device types, provider and software details
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 04-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.mosip_device_service | type: TABLE --
-- DROP TABLE IF EXISTS master.mosip_device_service CASCADE;
CREATE TABLE master.mosip_device_service(
	id character varying(36) NOT NULL,
	sw_binary_hash bytea NOT NULL,
	sw_version character varying(64) NOT NULL,
	dprovider_id character varying(36) NOT NULL,
	dtype_code character varying(36) NOT NULL,
	dstype_code character varying(36) NOT NULL,
	make character varying(36) NOT NULL,
	model character varying(36) NOT NULL,
	sw_cr_dtimes timestamp,
	sw_expiry_dtimes timestamp,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_mds_id PRIMARY KEY (id),
	CONSTRAINT uk_mds UNIQUE (sw_version,dprovider_id,dtype_code,dstype_code,make,model)

);
-- ddl-end --
COMMENT ON TABLE master.mosip_device_service IS 'MOSIP Device Service : Mosip device cervice to have all the details about the device types, provider and software details';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.id IS 'ID: Unigue service ID, Service ID is geerated by the MOSIP system';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.sw_binary_hash IS 'Software Binary Hash : Its is a software binary stored in MOSIP system for the devices';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.sw_version IS 'Software Version : Version of the stored software';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.dprovider_id IS 'Device Provider ID : Device provider ID, Referenced from master.device_provider.id';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.dtype_code IS 'Device Type Code: Code of the device type, Referenced from master.reg_device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.dstype_code IS ' Device Sub Type Code: Code of the device sub type, Referenced from master.reg_device_sub_type.code';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.make IS 'Make: Make of the device';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.model IS ' Model: Model of the device';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.sw_cr_dtimes IS 'Software Created Date Time: Date and Time on which this software is created';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.sw_expiry_dtimes IS 'Software Expiry Date Time: Expiry date and time of the device software';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.is_active IS 'IS_Active : Flag to mark whether the record/device is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.mosip_device_service.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --