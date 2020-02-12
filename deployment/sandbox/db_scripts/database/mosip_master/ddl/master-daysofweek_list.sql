-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.daysofweek_list
-- Purpose    	: Days of Week List : Stores all days of the week with Code and Name. The Days of week are kept with multiple language based on country configured languages..
--           
-- Create By   	: Sadanandegowda DM
-- Created Date	: 03-Sep-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------


-- object: master.daysofweek_list | type: TABLE --
-- DROP TABLE IF EXISTS master.daysofweek_list CASCADE;
CREATE TABLE master.daysofweek_list(
	code character varying(3) NOT NULL,
	name character varying(36) NOT NULL,
	day_seq smallint NOT NULL,
	is_global_working boolean NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_daysofweek_code PRIMARY KEY (code,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.daysofweek_list IS 'Days of Week List : Stores all days of the week with Code and Name. The Days of week are kept with multiple language based on country configured languages.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.code IS 'Code of the day of the week, This can be single digit like (M,T,W,R,F,S,U) or three digit like (MON,TUE,WED,THU,FRI,SAT,SUN)';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.name IS 'Name: Name of the day of the week, This is stored in multiple language based on the country requirement';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.day_seq IS 'Day Sequence : Day sequence is used to days in which order it has to be displyed for the country..like MON-1, TUE-2, WED-3....etc.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.is_global_working IS 'Global Is Working: Its a boolean value to define whether it is working or non-working day for the registration centers at global level.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.daysofweek_list.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --



