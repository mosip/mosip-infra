-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.key_store
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.key_store | type: TABLE --
-- DROP TABLE IF EXISTS reg.key_store CASCADE;
CREATE TABLE reg.key_store(
	id character varying(36) NOT NULL,
	public_key blob NOT NULL,
	valid_from_dtimes timestamp NOT NULL,
	valid_till_dtimes timestamp NOT NULL,
	ref_id character varying(64),
	status_code character varying(36),
	lang_code character varying(3),
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_keystr_id PRIMARY KEY (id)

);
-- ddl-end --
