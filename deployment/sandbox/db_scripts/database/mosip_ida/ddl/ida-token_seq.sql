-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_ida
-- Table Name 	: ida.token_seq
-- Purpose    	: Token ID Sequence: Stores sequence numbers that are used in the algorithm to generate token. Stores a incremental sequence number that will be used as salt in the algorithm to generate a token ID. This salt value is encrypted/hashed and used along with a seed number in the algorithm to generate a unique random number.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: ida.token_seq | type: TABLE --
-- DROP TABLE IF EXISTS ida.token_seq CASCADE;
CREATE TABLE ida.token_seq(
	seq_no character varying(32) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_tknseq PRIMARY KEY (seq_no)

);
-- ddl-end --
COMMENT ON TABLE ida.token_seq IS 'Token ID Sequence: Stores sequence numbers that are used in the algorithm to generate token. Stores a incremental sequence number that will be used as salt in the algorithm to generate a token ID. This salt value is encrypted/hashed and used along with a seed number in the algorithm to generate a unique random number.';
-- ddl-end --
COMMENT ON COLUMN ida.token_seq.seq_no IS 'Sequence Number: Sequence number is the number generated which is used in the algorithm to generate token ID.';
-- ddl-end --
COMMENT ON COLUMN ida.token_seq.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN ida.token_seq.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN ida.token_seq.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN ida.token_seq.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
