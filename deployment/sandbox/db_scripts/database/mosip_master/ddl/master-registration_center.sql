-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: master.registration_center
-- Purpose    	: Registration Center : List of registration centers that are authorized to perform UIN registrations.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: master.registration_center | type: TABLE --
-- DROP TABLE IF EXISTS master.registration_center CASCADE;
CREATE TABLE master.registration_center(
	id character varying(10) NOT NULL,
	name character varying(128) NOT NULL,
	cntrtyp_code character varying(36),
	addr_line1 character varying(256),
	addr_line2 character varying(256),
	addr_line3 character varying(256),
	latitude character varying(32),
	longitude character varying(32),
	location_code character varying(36) NOT NULL,
	contact_phone character varying(16),
	contact_person character varying(128),
	number_of_kiosks smallint,
	working_hours character varying(32),
	per_kiosk_process_time time,
	center_start_time time,
	center_end_time time,
	lunch_start_time time,
	lunch_end_time time,
	time_zone character varying(64),
	holiday_loc_code character varying(36),
	zone_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	is_active boolean NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_regcntr_code PRIMARY KEY (id,lang_code)

);
-- ddl-end --
COMMENT ON TABLE master.registration_center IS 'Registration Center : List of registration centers that are authorized to perform UIN registrations ';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.id IS 'Registration Center ID : Unique ID generated / assigned for a registration center';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.name IS 'Name : Registration center name';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.cntrtyp_code IS 'Center Type Code : different types of registration centers. Refers master.reg_center_type.code';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.addr_line1 IS 'Registration Center Address Line1 :  for ex. Number, street name, locality, etc.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.addr_line2 IS 'Registration Center Address Line2 :  for ex. Number, street name, locality, etc.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.addr_line3 IS 'Registration Center Address Line3 :  for ex.  locality, landmark, area etc.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.latitude IS 'Latitude: Latitude of the registration center location as per GPS standards / format';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.longitude IS 'Longitude: Longitude of the registration center location as per GPS standards / format';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.location_code IS 'Location Code: Location code of the registration center located. Refers to master.location.code';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.contact_phone IS 'Contact Phone :  Phone number of of the person to be contacted for any additional details.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.contact_person IS 'Contact Person :  Name of the person to be contacted for any additional details.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.number_of_kiosks IS 'Number of Kiosks: Total number of kiosks available at a registration center';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.working_hours IS 'Working hours: Working hours of a registration center (8.00 AM - 6.00 PM) ';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.per_kiosk_process_time IS 'Process Time Per Registration: Average process time for registration process per kiosk';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.center_start_time IS 'Center Start Time : registration center working opening hour / start time.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.center_end_time IS 'Center End Time : registration center working closing hour / end time.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.lunch_start_time IS 'Lunch Start Time: Registration centers lunch break start time';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.lunch_end_time IS 'Lunch End Time: Registration centers lunch break end time';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.time_zone IS 'Time Zone: Registration centers local timezone GMT, PST, IST';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.holiday_loc_code IS 'Holiday Location Code: Location code at which holidays are defined';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.zone_code IS 'Zone Code : Unique zone code generated or entered by admin while creating zones, It is referred to master.zone.code. ';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.is_active IS 'IS_Active : Flag to mark whether the record is Active or In-active';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN master.registration_center.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --

