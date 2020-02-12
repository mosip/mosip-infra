-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name : reg.role_list
-- Purpose    : 
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.role_list | type: TABLE --
-- DROP TABLE IF EXISTS reg.role_list CASCADE;
CREATE TABLE reg.role_list(
	code character varying(36) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rolelst_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
