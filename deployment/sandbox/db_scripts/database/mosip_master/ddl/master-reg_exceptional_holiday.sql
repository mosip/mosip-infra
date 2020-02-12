-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.reg_exceptional_holiday
-- Purpose    	: Registration Center Exceptional Holiday : Table to store all the exceptioanl holidays declared for the registartion centers. Will have all details on the exceptional holiday details like data, reason for holiday and registration center details.
--           
-- Create By   	: Sadanandegowda DM
-- Created Date	: 03-Sep-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: master.reg_exceptional_holiday | type: TABLE --
-- DROP TABLE IF EXISTS master.reg_exceptional_holiday CASCADE;
CREATE TABLE master.reg_exceptional_holiday(
	regcntr_id character varying(10) NOT NULL,
	hol_date date NOT NULL,
	hol_name character varying(128),
	hol_reason character varying(256),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_exceptional_hol PRIMARY KEY (regcntr_id,hol_date)

);
-- ddl-end --
COMMENT ON TABLE master.reg_exceptional_holiday IS 'Registration Center Exceptional Holiday : Table to store all the exceptioanl holidays declared for the registartion centers. Will have all details on the exceptional holiday details like data, reason for holiday and registration center details.';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.regcntr_id IS 'Registration Center ID : registration center id refers to master.registration_center.id, Registration centers id that are authorized to perform UIN registrations.';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.hol_date IS 'Holiday Date: Date of the exceptional holiday declared for specific registration center';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.hol_name IS 'Holiday Name: Name of the exceptional holiday or short description of the exceptional holiday';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.hol_reason IS 'Holiday Reason: Reason descrption for exceptioanl holiday';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.reg_exceptional_holiday.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --