-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reg_center_user_machine_h
-- Purpose    	: Registration Center User Machine History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.reg_center_user_machine table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.reg_center_user_machine_h | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_center_user_machine_h CASCADE;
CREATE TABLE master.reg_center_user_machine_h(
	regcntr_id character varying(10) NOT NULL,
	usr_id character varying(256) NOT NULL,
	machine_id character varying(10) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	eff_dtimes timestamp NOT NULL,
	CONSTRAINT pk_cntrmusr_h_usr_id PRIMARY KEY (regcntr_id,usr_id,machine_id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE master.reg_center_user_machine_h IS 'Registration Center User Machine History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.reg_center_user_machine table description for details.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.regcntr_id IS 'Registration Center ID : registration center id refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.usr_id IS 'User ID :  User id refers to master.user_detail.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.machine_id IS 'Machine ID : Machine id refers to master.machine_master.id';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
COMMENT ON COLUMN master.reg_center_user_machine_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --

