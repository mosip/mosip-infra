-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.loc_holiday
-- Purpose    	: Location Holiday : List of location specific holidays.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.loc_holiday | type: TABLE --
-- DROP TABLE IF EXISTS master.loc_holiday CASCADE;
CREATE TABLE master.loc_holiday(
	id integer NOT NULL,
	location_code character varying(36) NOT NULL,
	holiday_date date,
	holiday_name character varying(64),
	holiday_desc character varying(128),
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_lochol_id PRIMARY KEY (id,location_code,lang_code),
	CONSTRAINT uk_lochol_name UNIQUE (holiday_name,holiday_date,location_code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.loc_holiday IS 'Location Holiday : List of location specific holidays.  ';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.id IS 'Holiday ID : Unique id for each holiday';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.location_code IS 'Location Code: Location code refers to master.location.code';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.holiday_date IS 'Holiday Date: Calendar date';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.holiday_name IS 'Holiday Name: Name of the holiday';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.holiday_desc IS 'Holiday Description: Description of the holiday';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.loc_holiday.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --


