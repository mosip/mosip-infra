-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.app_authentication_method
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.app_authentication_method | type: TABLE --
-- DROP TABLE IF EXISTS reg.app_authentication_method CASCADE;
CREATE TABLE reg.app_authentication_method(
	app_id character varying(36) NOT NULL,
	process_id character varying(36) NOT NULL,
	role_code character varying(36) NOT NULL,
	auth_method_code character varying(36) NOT NULL,
	method_seq smallint,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_appauthm_id PRIMARY KEY (app_id,process_id,role_code,auth_method_code)

);
-- ddl-end --
