-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.mosip_device_service
-- Purpose    	: MOSIP Device Service : Mosip device cervice to have all the details about the device types, provider and software details
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 25-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.mosip_device_service | type: TABLE --
-- DROP TABLE IF EXISTS reg.mosip_device_service CASCADE;
CREATE TABLE reg.mosip_device_service(
	id character varying(36) NOT NULL,
	sw_binary_hash blob NOT NULL,
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