-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.machine_spec
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


-- object: reg.machine_spec | type: TABLE --
-- DROP TABLE IF EXISTS reg.machine_spec CASCADE;
CREATE TABLE reg.machine_spec(
	id character varying(36) NOT NULL,
	name character varying(64) NOT NULL,
	brand character varying(32) NOT NULL,
	model character varying(16) NOT NULL,
	mtyp_code character varying(36) NOT NULL,
	min_driver_ver character varying(16) NOT NULL,
	descr character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_mspec_code PRIMARY KEY (id,lang_code)

);
-- ddl-end --
