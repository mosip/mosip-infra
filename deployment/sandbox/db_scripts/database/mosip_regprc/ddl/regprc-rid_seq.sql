-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.rid_seq
-- Purpose    	: Registration ID Sequence: regprc tables to keep the current Registration ID sequence, Machine ID and Registration Center ID.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.rid_seq | type: TABLE --
-- DROP TABLE IF EXISTS regprc.rid_seq CASCADE;
CREATE TABLE regprc.rid_seq(
	regcntr_id character varying(10) NOT NULL,
	machine_id character varying(10) NOT NULL,
	curr_seq_no integer NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_ridseq_id PRIMARY KEY (regcntr_id,machine_id)

);
-- ddl-end --
COMMENT ON TABLE regprc.rid_seq IS 'Registration ID Sequence: regprc tables to keep the current Registration ID sequence, Machine ID and Registration Center ID';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.regcntr_id IS 'Registration Center ID: Registration center id which is refered to use the sequence while generation registration ID';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.machine_id IS 'Machine ID: Machine id which is refered to use the sequence while generation registration ID';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.curr_seq_no IS 'Current Sequence Number: : Latest sequence number available for counter that is used in RID generation';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.rid_seq.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --

