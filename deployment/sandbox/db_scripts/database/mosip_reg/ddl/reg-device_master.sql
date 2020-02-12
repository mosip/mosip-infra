-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.device_master
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: reg.device_master | type: TABLE --
-- DROP TABLE IF EXISTS reg.device_master CASCADE;
CREATE TABLE reg.device_master(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	mac_address character varying(64) NOT NULL,
	serial_num character varying(64) NOT NULL,
	ip_address character varying(17),
	validity_end_dtimes timestamp,
	dspec_id character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_devicem_id PRIMARY KEY (id,lang_code)

);
-- ddl-end --
