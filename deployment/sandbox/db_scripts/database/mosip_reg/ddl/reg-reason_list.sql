-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.reason_list
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.reason_list | type: TABLE --
-- DROP TABLE IF EXISTS reg.reason_list CASCADE;
CREATE TABLE reg.reason_list(
	code character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	descr character varying(256),
	rsncat_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rsnlst_code PRIMARY KEY (code,rsncat_code,lang_code)

);
-- ddl-end --
