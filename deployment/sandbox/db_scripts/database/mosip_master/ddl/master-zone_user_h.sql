-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.zone_user_h
-- Purpose    	: Zone User History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.zone_user table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.zone_user_h | type: TABLE --
-- DROP TABLE IF EXISTS master.zone_user_h CASCADE;
CREATE TABLE master.zone_user_h(
	zone_code 	character varying(36) NOT NULL,
	usr_id 		character varying(256) NOT NULL,
	lang_code 	character varying(3),
	is_active 	boolean NOT NULL,
	cr_by 		character varying(256) NOT NULL,
	cr_dtimes 	timestamp NOT NULL,
	upd_by 		character varying(256),
	upd_dtimes 	timestamp,
	is_deleted 	boolean,
	del_dtimes 	timestamp,
	eff_dtimes 	timestamp NOT NULL,
	CONSTRAINT pk_zoneuserh PRIMARY KEY (zone_code,usr_id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE master.zone_user_h IS 'Zone User History : This to track changes to master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer master.zone_user table description for details.';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.zone_code IS 'Code : Unique zone code generated or entered by admin while creating zones. ';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.usr_id IS 'User ID :  ID of the user which is mapped to zone, This user will have defined roles based on which user is mapped to zones.';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
COMMENT ON COLUMN master.zone_user_h.eff_dtimes IS 'Effective Date Timestamp : This to track master record whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time. ';
-- ddl-end --

