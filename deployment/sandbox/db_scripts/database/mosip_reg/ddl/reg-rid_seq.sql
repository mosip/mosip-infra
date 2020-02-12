-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name : reg.rid_seq
-- Purpose    : 
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: reg.rid_seq | type: TABLE --
-- DROP TABLE IF EXISTS reg.rid_seq CASCADE;
CREATE TABLE reg.rid_seq(
	curr_seq_no integer NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_ridseq_id PRIMARY KEY (curr_seq_no)

);
-- ddl-end --
