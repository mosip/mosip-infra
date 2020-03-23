-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.reg_appointment
-- Purpose    	: Registration Appointment: Stores all the appointment requests booked by an individual at a registration center.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.reg_appointment | type: TABLE --
-- DROP TABLE IF EXISTS prereg.reg_appointment CASCADE;
CREATE TABLE prereg.reg_appointment(
	id character varying(36) NOT NULL,
	regcntr_id character varying(10) NOT NULL,
	prereg_id character varying(36) NOT NULL,
	booking_dtimes timestamp NOT NULL,
	appointment_date date,
	slot_from_time time,
	slot_to_time time,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_rappmnt_id PRIMARY KEY (id),
	CONSTRAINT uk_rappmnt_id UNIQUE (prereg_id)

);
-- ddl-end --
COMMENT ON TABLE prereg.reg_appointment IS 'Registration Appointment: Stores all the appointment requests booked by an individual at a registration center. ';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.id IS 'ID: Unique id generated for the registration appointment booking.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.regcntr_id IS 'Registration Center ID: Id of the Registration Center where the appointment is taken. Refers to master.registration_center.id';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.prereg_id IS 'Pre-Registration Id: Pre-registration id for which registration appointment is taken.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.booking_dtimes IS 'Booking Date Time: Date and Time when the appointment booking is done.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.appointment_date IS 'Appointment Date: Date for which an individual has taken an aopointment for registration at a registration center';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.slot_from_time IS 'Slot From Time: Start time of the appointment slot.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.slot_to_time IS 'Slot To Time: End time of the appointment slot.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.reg_appointment.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
