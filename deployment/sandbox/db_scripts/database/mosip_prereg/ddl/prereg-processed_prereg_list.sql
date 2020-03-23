-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.processed_prereg_list
-- Purpose    	: Table to store all the pre-registration list received from registration processor within pre-registration module
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.processed_prereg_list | type: TABLE --
-- DROP TABLE IF EXISTS prereg.processed_prereg_list CASCADE;
CREATE TABLE prereg.processed_prereg_list(
	prereg_id character varying(36) NOT NULL,
	first_received_dtimes timestamp NOT NULL,
	status_code character varying(36) NOT NULL,
	status_comments character varying(1024),
	prereg_trn_id character varying(36),
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pprlst_pk PRIMARY KEY (prereg_id)

);
-- ddl-end --
COMMENT ON TABLE prereg.processed_prereg_list IS 'Table to store all the pre-registration list received from registration processor within pre-registration module';
-- ddl-end --
COMMENT ON COLUMN prereg.processed_prereg_list.prereg_id IS 'Pre-registration id that was consumed by registration processor to generate UIN';
-- ddl-end --
COMMENT ON COLUMN prereg.processed_prereg_list.first_received_dtimes IS 'Datetime when the pre-registration id was first recevied';
-- ddl-end --
COMMENT ON COLUMN prereg.processed_prereg_list.status_code IS 'status of the pre-registration status update into actual tables';
-- ddl-end --
COMMENT ON COLUMN prereg.processed_prereg_list.status_comments IS 'status comments of the pre-registration status update into actual tables';
-- ddl-end --

