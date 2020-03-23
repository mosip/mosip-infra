-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name 	: reg.pre_registration_list
-- Purpose    	: 
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.pre_registration_list | type: TABLE --
-- DROP TABLE IF EXISTS reg.pre_registration_list CASCADE;
CREATE TABLE reg.pre_registration_list(
	id character varying(36) NOT NULL,
	prereg_id character varying(64) NOT NULL,
	prereg_type character varying(64),
	parent_prereg_id character varying(64),
	appointment_date date,
	packet_symmetric_key character varying(256),
	status_code character varying(36),
	status_comment character varying(256),
	packet_path character varying(256),
	sjob_id character varying(36),
	synctrn_id character varying(36),
	last_upd_dtimes timestamp,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_preregl_id PRIMARY KEY (id)

);
-- ddl-end --
