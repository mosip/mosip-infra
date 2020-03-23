-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_regprc
-- Table Name 	: regprc.reg_lost_uin_det
-- Purpose    	: Registration Lost UIN: Table to store lost uin related details. Mostly to store the latest RID of the lost UIN of an individual who lost his / her UIN.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: regprc.reg_lost_uin_det | type: TABLE --
-- DROP TABLE IF EXISTS regprc.reg_lost_uin_det CASCADE;
CREATE TABLE regprc.reg_lost_uin_det(
	reg_id character varying(39) NOT NULL,
	latest_reg_id character varying(36) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_rlostd PRIMARY KEY (reg_id)

);
-- ddl-end --
COMMENT ON TABLE regprc.reg_lost_uin_det IS 'Registration Lost UIN: Table to store lost uin related details. Mostly to store the latest RID of the lost UIN of an individual who lost his / her UIN.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.reg_id IS 'Registration ID: Registration id of the lost uin request by an individual as received by the registration client application.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.latest_reg_id IS 'Latest Registration ID: Latest registration id of the UIN for which UIN lost request has been raised. ';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN regprc.reg_lost_uin_det.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

