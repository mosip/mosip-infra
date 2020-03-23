-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.registered_device_master
-- Purpose    	: Registered Device Master : Contains list of registered devices and details, like fingerprint scanner, iris scanner, scanner etc used at registration centers, authentication services, eKYC...etc. Valid devices with active status only allowed at registering devices for respective functionalities. Device onboarding are handled through admin application/portal by the user who is having the device onboarding authority. 
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 25-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.registered_device_master | type: TABLE --
-- DROP TABLE IF EXISTS reg.registered_device_master CASCADE;
CREATE TABLE reg.registered_device_master(
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
	make character varying(36) NOT NULL,
	model character varying(36) NOT NULL,
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