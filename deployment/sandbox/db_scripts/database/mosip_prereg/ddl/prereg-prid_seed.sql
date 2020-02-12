-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.prid_seed
-- Purpose    	: Pre-Registration ID Seed: Stores a random number that will be used as seed in the algorithm to generate a PRID. This seed value is encrypted/hashed and used along with a counter in the algorithm to generate a unique random number. Only one seed value would be available for the generation of PRID and this will never change.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.prid_seed | type: TABLE --
-- DROP TABLE IF EXISTS prereg.prid_seed CASCADE;
CREATE TABLE prereg.prid_seed(
	seed_no character varying(32) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_prsd PRIMARY KEY (seed_no)

);
-- ddl-end --
COMMENT ON TABLE prereg.prid_seed IS 'Pre-Registration ID Seed: Stores a random number that will be used as seed in the algorithm to generate a PRID. This seed value is encrypted/hashed and used along with a counter in the algorithm to generate a unique random number. Only one seed value would be available for the generation of PRID and this will never change.';
-- ddl-end --
COMMENT ON COLUMN prereg.prid_seed.seed_no IS 'Seed Number: Seed number is the random number generated which will be used as seed in the algorithm to generate PRID.';
-- ddl-end --
COMMENT ON COLUMN prereg.prid_seed.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.prid_seed.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.prid_seed.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN prereg.prid_seed.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

