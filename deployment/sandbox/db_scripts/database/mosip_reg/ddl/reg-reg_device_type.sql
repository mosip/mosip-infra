-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.reg_device_type
-- Purpose    	: Device Type : Types of devices that are supported by the MOSIP system,  like  scanning, finger, face, iris etc
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 25-Oct-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: reg.reg_device_type | type: TABLE --
-- DROP TABLE IF EXISTS reg.reg_device_type CASCADE;
CREATE TABLE reg.reg_device_type(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(512),
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rdtyp_code PRIMARY KEY (code)

);