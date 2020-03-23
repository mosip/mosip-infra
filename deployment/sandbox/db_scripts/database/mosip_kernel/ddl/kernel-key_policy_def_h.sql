-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_kernel
-- Table Name 	: kernel.key_policy_def_h
-- Purpose    	: Key Policy Definition History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer kernel.key_policy_def table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: kernel.key_policy_def_h | type: TABLE --
-- DROP TABLE IF EXISTS kernel.key_policy_def_h CASCADE;
CREATE TABLE kernel.key_policy_def_h(
	app_id character varying(36) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	key_validity_duration smallint,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_keypdefh_id PRIMARY KEY (app_id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE kernel.key_policy_def_h IS 'Key Policy Definition History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer kernel.key_policy_def table description for details.   ';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.app_id IS 'Application ID: Application id for which the key policy is defined';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.key_validity_duration IS 'Key Validity Duration: Duration for which key is valid';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN kernel.key_policy_def_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

