-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_idmap
-- Table Name 	: idmap.vid_seq
-- Purpose    	: Virtual ID Sequence: Stores sequence numbers that are used in the algorithm to generate vid. Stores a incremental sequence number that will be used as salt in the algorithm to generate a vid. This salt value is encrypted/hashed and used along with a seed number in the algorithm to generate a unique random number.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idmap.vid_seq | type: TABLE --
-- DROP TABLE IF EXISTS idmap.vid_seq CASCADE;
CREATE TABLE idmap.vid_seq(
	seq_no character varying(32) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_vidseq PRIMARY KEY (seq_no)

);
-- ddl-end --
COMMENT ON TABLE idmap.vid_seq IS 'Virtual ID Sequence: Stores sequence numbers that are used in the algorithm to generate vid. Stores a incremental sequence number that will be used as salt in the algorithm to generate a vid. This salt value is encrypted/hashed and used along with a seed number in the algorithm to generate a unique random number.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seq.seq_no IS 'Sequence Number: Sequence number is the number generated which is used in the algorithm to generate vid.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seq.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seq.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seq.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seq.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
