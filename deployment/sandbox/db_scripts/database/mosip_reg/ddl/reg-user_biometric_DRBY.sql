-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.user_biometric
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


-- object: reg.user_biometric | type: TABLE --
-- DROP TABLE IF EXISTS reg.user_biometric CASCADE;
CREATE TABLE reg.user_biometric(
	usr_id character varying(256) NOT NULL,
	bmtyp_code character varying(36) NOT NULL,
	bmatt_code character varying(36) NOT NULL,
	bio_raw_image blob(1M),
	bio_minutia clob(1M),
	bio_iso_image blob(1M),
	quality_score numeric(5,3),
	no_of_retry smallint,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_usrbio_bmatt_code PRIMARY KEY (usr_id,bmtyp_code,bmatt_code)

);
-- ddl-end --

