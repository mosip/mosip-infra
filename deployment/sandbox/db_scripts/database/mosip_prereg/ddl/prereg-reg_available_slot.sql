-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.reg_available_slot
-- Purpose    	: Registration Available Slots: Slots available at a registration center for an individual to book for registrating themselves to get a UIN.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.reg_available_slot | type: TABLE --
-- DROP TABLE IF EXISTS prereg.reg_available_slot CASCADE;
CREATE TABLE prereg.reg_available_slot(
	regcntr_id character varying(10) NOT NULL,
	availability_date date NOT NULL,
	slot_from_time time NOT NULL,
	slot_to_time time,
	available_kiosks smallint,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_ravlslt_id PRIMARY KEY (regcntr_id,availability_date,slot_from_time)

);
-- ddl-end --
COMMENT ON TABLE prereg.reg_available_slot IS 'Registration Available Slots: Slots available at a registration center for an individual to book for registrating themselves to get a UIN. ';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.regcntr_id IS 'Registration Center ID: Id of the Registration Center where the appointment can be booded for registration process. Refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.availability_date IS 'Avalilability Date: Date when the registration center is available for registration process.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.slot_from_time IS 'Slot From Time: Start time of the appointment slot available for booking at a registration center.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.slot_to_time IS 'Slot To Time: End time of the appointment slot available for booking at a registration center.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.available_kiosks IS 'Available Kiosks: Number of kiosks available for booking at a registration center.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_available_slot.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
