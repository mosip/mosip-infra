-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.template
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


-- object: reg.template | type: TABLE --
-- DROP TABLE IF EXISTS reg.template CASCADE;
CREATE TABLE reg.template(
	id character varying(36) NOT NULL,
	name character varying(128) NOT NULL,
	descr character varying(256),
	file_format_code character varying(36) NOT NULL,
	model character varying(128),
	file_txt character varying(4086),
	module_id character varying(36),
	module_name character varying(128),
	template_typ_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_tmplt_id PRIMARY KEY (id,lang_code)

);
-- ddl-end --
