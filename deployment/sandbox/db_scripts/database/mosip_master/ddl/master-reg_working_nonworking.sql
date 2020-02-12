-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: reg_working_nonworking
-- Purpose    	: Registration Center Working NonWorking : Stores working and non-working days of the week for all registration centers. As per the requirement working and non-working days are defined at center level.
--           
-- Create By   	: Sadanandegowda DM
-- Created Date	: 03-Sep-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: master.reg_working_nonworking | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_working_nonworking CASCADE;
CREATE TABLE master.reg_working_nonworking(
	regcntr_id character varying(10) NOT NULL,
	day_code character varying(3) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_working boolean NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_working_nonworking PRIMARY KEY (regcntr_id,day_code)

);
-- ddl-end --
COMMENT ON TABLE master.reg_working_nonworking IS 'Registration Center Working NonWorking : Stores working and non-working days of the week for all registration centers. As per the requirement working and non-working days are defined at center level.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.regcntr_id IS 'Registration Center ID : registration center id refers to master.registration_center.id, Registration centers id that are authorized to perform UIN registrations.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.day_code IS 'Code of the day of the week, This can be single digit like (M,T,W,R,F,S,U) or three digit like (MON,TUE,WED,THU,FRI,SAT,SUN). This attribute Refers master.daysofweek_list.code';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.is_working IS 'Is Working: Its a boolean value to define whether it is working or non-working day for the registration center.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_working_nonworking.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --