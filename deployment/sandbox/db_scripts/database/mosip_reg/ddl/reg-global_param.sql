-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.global_param
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.global_param | type: TABLE --
-- DROP TABLE IF EXISTS reg.global_param CASCADE;
CREATE TABLE reg.global_param(
	code character varying(128) NOT NULL,
	name character varying(128) NOT NULL,
	val character varying(512),
	typ character varying(128) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_glbparm_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
