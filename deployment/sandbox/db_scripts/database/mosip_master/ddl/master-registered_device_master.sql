-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.registered_device_master
-- Purpose    	: Registered Device Master : Contains list of registered devices and details, like fingerprint scanner, iris scanner, scanner etc used at registration centers, authentication services, eKYC...etc. Valid devices with active status only allowed at registering devices for respective functionalities. Device onboarding are handled through admin application/portal by the user who is having the device onboarding authority. 
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 04-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 30-Dec-2019          Sadanandegowda      Removed some attributes as per the new API specs
-- ------------------------------------------------------------------------------------------

-- object: master.registered_device_master | type: TABLE --
-- DROP TABLE IF EXISTS master.registered_device_master CASCADE;
CREATE TABLE master.registered_device_master(
	code character varying(36) NOT NULL,
	dtype_code character varying(36) NOT NULL,
	dstype_code character varying(36) NOT NULL,
	status_code character varying(64),
	device_id character varying(256) NOT NULL,
	device_sub_id character varying(256),
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
	CONSTRAINT pk_regdevicem_code PRIMARY KEY (code),
	CONSTRAINT uk_regdevm_id UNIQUE (serial_number,provider_id)

);
-- ddl-end --
COMMENT ON TABLE master.registered_device_master IS 'Registered Device Master : Contains list of registered devices and details, like fingerprint scanner, iris scanner, scanner etc used at registration centers, authentication services, eKYC...etc. Valid devices with active status only allowed at registering devices for respective functionalities. Device onboarding are handled through admin application/portal by the user who is having the device onboarding authority. ';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.code IS 'Registred Device Code : Unique ID generated / assigned for device which is registred in MOSIP system for the purpose';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.dtype_code IS 'Device Type Code: Code of the device type, Referenced from master.reg_device_type.code';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.dstype_code IS 'Device Sub Type Code: Code of the device sub type, Referenced from master.reg_device_sub_type.code';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.status_code IS 'Status Code : Status of the registered devices, The status code can be Registered, De-Registered or Retired/Revoked.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.device_id IS 'Device ID: Device ID is the unigue id provided by device provider for each device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.device_sub_id IS 'Device Sub ID: Sub ID of the devices, Each device can have an array of sub IDs.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.digital_id IS 'Digital ID: Digital ID received as a Json value containing below values like Serial number of the device, make , model, type, provider details..etc';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.serial_number IS 'Serial Number : Serial number of the device, This will be the Unique ID of the device by the provider';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.provider_id IS 'Device Provider ID: ID of the device provider, Referenced from master.device_provider.id';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.provider_name IS 'Device Provider Name : Name of the device provider, This also available in master.device_provider entity';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.purpose IS 'Purpose : Purpose of these devices in the MOSIP system. ex. Registrations, Authentication, eKYC...etc';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.firmware IS 'Firmware: Firmware used in devices';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.make IS 'Make: Make of the device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.expiry_date IS 'Expiry Date: expiry date of the device';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.certification_level IS 'Certification Level: Certification level for the device, This can be L0 or L1 devices';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.foundational_trust_provider_id IS 'Foundational Trust Provider ID: Foundational trust provider ID, This will be soft referenced from master.foundational_trust_provider.id. Required only for L1 devices.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.is_active IS 'IS_Active : Flag to mark whether the record/device is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.registered_device_master.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --