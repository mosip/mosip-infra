-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.device_provider
-- Purpose    	: Device Provider : To store MOSIP device provider details, Devices will be used in MOSIP those are provided by only registred device provider.
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 25-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: reg.device_provider | type: TABLE --
-- DROP TABLE IF EXISTS reg.device_provider CASCADE;
CREATE TABLE reg.device_provider(
	id character varying(36) NOT NULL,
	vendor_name character varying(128) NOT NULL,
	address character varying(512),
	email character varying(512),
	contact_number character varying(16),
	certificate_alias character varying(36),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_devprd_id PRIMARY KEY (id)

);