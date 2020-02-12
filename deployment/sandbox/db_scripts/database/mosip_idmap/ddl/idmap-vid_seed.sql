-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_idmap
-- Table Name 	: idmap.vid_seed
-- Purpose    	: Virtual ID Seed: Stores a random number that will be used as seed in the algorithm to generate a vid. This seed value is encrypted/hashed and used along with a counter in the algorithm to generate a unique random number. Only one seed value would be available for the generation of vid and this will never change.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idmap.vid_seed | type: TABLE --
-- DROP TABLE IF EXISTS idmap.vid_seed CASCADE;
CREATE TABLE idmap.vid_seed(
	seed_no character varying(32) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_vidsd PRIMARY KEY (seed_no)

);
-- ddl-end --
COMMENT ON TABLE idmap.vid_seed IS 'Virtual ID Seed: Stores a random number that will be used as seed in the algorithm to generate a vid. This seed value is encrypted/hashed and used along with a counter in the algorithm to generate a unique random number. Only one seed value would be available for the generation of vid and this will never change.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seed.seed_no IS 'Seed Number: Seed number is the random number generated which will be used as seed in the algorithm to generate vid.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seed.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seed.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seed.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idmap.vid_seed.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
