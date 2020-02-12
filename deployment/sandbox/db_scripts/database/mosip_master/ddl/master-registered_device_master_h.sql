-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.registered_device_master_h
-- Purpose    	: Registered Device History : History of changes of any MOSIP device registration will be stored in history table to track any chnages for future validations.
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 04-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 30-Dec-2019          Sadanandegowda      Removed some attributes as per the new API specs
-- ------------------------------------------------------------------------------------------

-- object: master.registered_device_master_h | type: TABLE --
-- DROP TABLE IF EXISTS master.registered_device_master_h CASCADE;
CREATE TABLE master.registered_device_master_h(
	code character varying(36) NOT NULL,
	dtype_code character varying(36) NOT NULL,
	dstype_code character varying(36) NOT NULL,
	status_code character varying(64),
	device_id character varying(256) NOT NULL,
	device_sub_id character varying(1024),
	digital_id character varying(1024) NOT NULL,
	serial_number character varying(64) NOT NULL,
	provider_id character varying(36) NOT NULL,
	provider_name character varying(128),
	purpose character varying(64) NOT NULL,
	firmware character varying(128),
	make character varying(36),
	model character varying(36),
	expiry_date timestamp,
	certification_level character varying(3),
	foundational_trust_provider_id character varying(36),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	eff_dtimes timestamp NOT NULL,
	CONSTRAINT pk_regdevicemh_code PRIMARY KEY (code,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE master.registered_device_master_h IS 'Registered Device History : History of changes of any MOSIP device registration will be stored in history table to track any chnages for future validations.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.code IS 'Registred Device Code : Unique ID generated / assigned for device which is registred in MOSIP system for the purpose';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.dtype_code IS 'Device Type Code: Code of the device type, Referenced from master.reg_device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.dstype_code IS 'Device Sub Type Code: Code of the device sub type, Referenced from master.reg_device_sub_type.code';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.status_code IS 'Status Code : Status of the registered devices, The status code can be Registered, De-Registered or Retired/Revoked.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.device_id IS 'Device ID: Device ID is the unigue id provided by device provider for each device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.device_sub_id IS 'Device Sub ID: Sub ID of the devices, Each device can have an array of sub IDs.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.digital_id IS 'Digital ID: Digital ID received as a Json value containing below values like Serial number of the device, make , model, type, provider details..etc';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.serial_number IS 'Serial Number : Serial number of the device, This will be the Unique ID of the device by the provider';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.provider_id IS 'Device Provider ID: ID of the device provider, Referenced from master.device_provider.id';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.provider_name IS 'Device Provider Name : Name of the device provider, This also available in master.device_provider entity';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.purpose IS 'Purpose : Purpose of these devices in the MOSIP system. ex. Registrations, Authentication, eKYC...etc';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.firmware IS 'Firmware: Firmware used in devices';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.make IS 'Make: Make of the device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.expiry_date IS 'Expiry Date: expiry date of the device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.certification_level IS 'Certification Level: Certification level for the device, This can be L0 or L1 devices';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.foundational_trust_provider_id IS 'Foundational Trust Provider ID: Foundational trust provider ID, This will be soft referenced from master.foundational_trust_provider.id. Required only for L1 devices.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time.';
-- ddl-end --