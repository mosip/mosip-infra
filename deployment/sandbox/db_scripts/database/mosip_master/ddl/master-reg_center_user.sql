-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reg_center_user
-- Purpose    	: Registration Center User : List of authorized users assigned to a registration center.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.reg_center_user | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_center_user CASCADE;
CREATE TABLE master.reg_center_user(
	regcntr_id character varying(10) NOT NULL,
	usr_id character varying(256) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_cntrusr_usr_id PRIMARY KEY (regcntr_id,usr_id)

);
-- ddl-end --
COMMENT ON TABLE master.reg_center_user IS 'Registration Center User : List of authorized users assigned to a registration center.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.regcntr_id IS 'Registration Center ID : registration center id refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.usr_id IS 'User ID :  User id refers to master.user_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

