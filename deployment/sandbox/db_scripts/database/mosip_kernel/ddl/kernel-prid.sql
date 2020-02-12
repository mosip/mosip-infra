-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.prid
-- Purpose    	: PRID: Stores pre-generated PRIDs that are assigned to an individual as part of mosip preregistration process
--           
-- Create By   	: Sadanandegowda
-- Created Date	: 30-Nov-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: kernel.prid | type: TABLE --
-- DROP TABLE IF EXISTS kernel.prid CASCADE;
CREATE TABLE kernel.prid(
	prid character varying(36) NOT NULL,
	prid_status character varying(16) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_prid_id PRIMARY KEY (prid)

);
-- ddl-end --
COMMENT ON TABLE kernel.prid IS 'PRID: Stores pre-generated PRIDs that are assigned to an individual as part of mosip preregistration process';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.prid IS 'PRID: Pre-generated PRIDs (Pre registration IDs), which will be used to assign to an individual';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.prid_status IS 'PRID Status: Status of the pre-generated PRID, whether it is available, expired or assigned.';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.prid.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --