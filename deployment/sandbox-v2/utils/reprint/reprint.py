from typing import Dict

from api import MosipSession
from classes.bookingSlot import BookingSlot
from dataTransformer import abs_transformedRecords_path
from db import DatabaseSession
import config as conf
from inputDataParser import getInputToIdSchemaMapping
from utils import get_json_file, myprint, keyExists


class ScriptRunner:

    def __init__(self):
        self.input_to_idschema: Dict = getInputToIdSchemaMapping()
        self.api_helper = MosipSession(conf.server, conf.client_id, conf.secret_key, conf.app_id,
                                       ssl_verify=conf.ssl_verify)
        self.db_session = DatabaseSession(conf.db_host, conf.db_port, conf.db_user, conf.db_pass)
        self.execute()

    def execute(self):
        myprint("Deleting all existing PRIDs from mosip_kernel.prid", 2)
        self.db_session.deleteUnAssignedPridFromKernel()
        records = get_json_file(abs_transformedRecords_path)
        if records is not None:
            for record in records:
                myprint("Processing record: ARN " + record['arn'], 2)
                application_info = self.db_session.getApplication(record['arn'])
                if application_info is None:
                    myprint("Inserting PRID to kernel: ARN " + record['arn'])
                    self.db_session.insertPridToKernel(record['arn'])
                    myprint("Creating application: ARN " + record['arn'])
                    application = self.createApplication(record)
                    myprint("Successfully created application: ARN " + record['arn'], 12)
                    app_status = application['statusCode']
                else:
                    app_status = application_info['status_code']
                    myprint("Skipping application creation as record already exists: ARN " + record['arn'], 11)

                slot_info: BookingSlot = self.getSlot(record)
                if slot_info is not None:
                    appointment_count = self.db_session.appointmentCountByPrid(record['arn'])
                    if appointment_count == 0:
                        self.createBookingSlot(slot_info)
                        if app_status == 'Booked':
                            self.db_session.updateApplicationStatus(record['arn'], 'Pending_Appointment')
                        self.bookAppointment(slot_info)
                    else:
                        myprint("Skipping appointment creation as appointment already exists: ARN " + record['arn'], 11)
                else:
                    myprint("No appointment found: ARN " + record['arn'], 11)

                # self.db_session.updatePreregCreatedBy(record['arn'], record[self.input_to_idschema['phone']['final']])
        else:
            raise ValueError("Records not found in transformed data")

    def createApplication(self, record):
        data = {}
        data['IDSchemaVersion'] = '0.1'
        # name
        data[self.input_to_idschema['firstName']['final']] = self.getSimpleType(
            record[self.input_to_idschema['firstName']['final']]
        )
        data[self.input_to_idschema['lastName']['final']] = self.getSimpleType(
            record[self.input_to_idschema['lastName']['final']]
        )
        data[self.input_to_idschema['middleName']['final']] = self.getSimpleType(
            record[self.input_to_idschema['middleName']['final']]
        )
        data[self.input_to_idschema['suffix']['final']] = self.getSimpleType(
            record[self.input_to_idschema['suffix']['final']]
        )

        # personal
        if keyExists(self.input_to_idschema['gender']['final'], record) and \
                record[self.input_to_idschema['gender']['final']]:
            data[self.input_to_idschema['gender']['final']] = self.getSimpleType(
                record[self.input_to_idschema['gender']['final']]
            )

        if keyExists(self.input_to_idschema['dateOfBirth']['final'], record) and \
                record[self.input_to_idschema['dateOfBirth']['final']]:
            data[self.input_to_idschema['dateOfBirth']['final']] = record[self.input_to_idschema['dateOfBirth']['final']]

        if keyExists(self.input_to_idschema['bloodType']['final'], record) and \
                record[self.input_to_idschema['bloodType']['final']]:
            data[self.input_to_idschema['bloodType']['final']] = self.getSimpleType(
                record[self.input_to_idschema['bloodType']['final']]
            )

        if keyExists(self.input_to_idschema['residenceStatus']['final'], record) and \
                record[self.input_to_idschema['residenceStatus']['final']]:
            data[self.input_to_idschema['residenceStatus']['final']] = self.getSimpleType(
                record[self.input_to_idschema['residenceStatus']['final']]
            )

        if keyExists(self.input_to_idschema['maritalStatus']['final'], record) and \
                record[self.input_to_idschema['maritalStatus']['final']]:
            data[self.input_to_idschema['maritalStatus']['final']] = self.getSimpleType(
                record[self.input_to_idschema['maritalStatus']['final']]
            )

        if keyExists(self.input_to_idschema['phone']['final'], record) and \
                record[self.input_to_idschema['phone']['final']]:
            data[self.input_to_idschema['phone']['final']] = record[self.input_to_idschema['phone']['final']]

        if keyExists(self.input_to_idschema['email']['final'], record) and \
                record[self.input_to_idschema['email']['final']]:
            data[self.input_to_idschema['email']['final']] = record[self.input_to_idschema['email']['final']]

        # birth address
        data[self.input_to_idschema['pobCountry']['final']] = self.getSimpleType(
            record[self.input_to_idschema['pobCountry']['final']]
        )
        data[self.input_to_idschema['pobProvince']['final']] = self.getSimpleType(
            record[self.input_to_idschema['pobProvince']['final']]
        )
        data[self.input_to_idschema['pobCity']['final']] = self.getSimpleType(
            record[self.input_to_idschema['pobCity']['final']]
        )

        # permanent address
        data[self.input_to_idschema['permanentCountry']['final']] = self.getSimpleType(
            record[self.input_to_idschema['permanentCountry']['final']]
        )
        data[self.input_to_idschema['permanentProvince']['final']] = self.getSimpleType(
            record[self.input_to_idschema['permanentProvince']['final']]
        )
        data[self.input_to_idschema['permanentCity']['final']] = self.getSimpleType(
            record[self.input_to_idschema['permanentCity']['final']]
        )
        data[self.input_to_idschema['permanentBarangay']['final']] = self.getSimpleType(
            record[self.input_to_idschema['permanentBarangay']['final']]
        )
        data[self.input_to_idschema['permanentAddressLine']['final']] = self.getSimpleType(
            record[self.input_to_idschema['permanentAddressLine']['final']]
        )

        # present address
        data[self.input_to_idschema['presentCountry']['final']] = self.getSimpleType(
            record[self.input_to_idschema['presentCountry']['final']]
        )
        data[self.input_to_idschema['presentProvince']['final']] = self.getSimpleType(
            record[self.input_to_idschema['presentProvince']['final']]
        )
        data[self.input_to_idschema['presentCity']['final']] = self.getSimpleType(
            record[self.input_to_idschema['presentCity']['final']]
        )
        data[self.input_to_idschema['presentBarangay']['final']] = self.getSimpleType(
            record[self.input_to_idschema['presentBarangay']['final']]
        )
        data[self.input_to_idschema['presentAddressLine']['final']] = self.getSimpleType(
            record[self.input_to_idschema['presentAddressLine']['final']]
        )
        res = self.api_helper.addApplication(data)
        prid = res['preRegistrationId']
        myprint("Checking PRID (" + prid + ") matches with ARN (" + record['arn'] + ")")
        if prid != record['arn']:
            raise RuntimeError("Inserted records PRID: expected [" + record['arn'] + ", actual [" + prid + "]")
        return res

    def createBookingSlot(self, slot_info: BookingSlot):
        myprint("Checking Slot for ARN: " + slot_info.prid)
        res = self.db_session.checkSlot(slot_info)
        if res is not None:
            if res['available_kiosks'] > res['appointments']:
                myprint("Slot found for ARN: " + slot_info.prid)
            else:
                myprint("Updating slot for ARN, : " + slot_info.prid)
                self.db_session.updateSlot(slot_info, res['appointments'] + 1)
        else:
            myprint("Creating slot for ARN: " + slot_info.prid)
            self.db_session.createSlot(slot_info)
        return

    def bookAppointment(self, slot_info: BookingSlot):
        data = {
            "preRegistrationId": slot_info.prid,
            "registration_center_id": slot_info.registration_center,
            "appointment_date": slot_info.slot_date,
            "time_slot_from": slot_info.slot_time_from,
            "time_slot_to": slot_info.slot_time_to
        }
        res = self.api_helper.bookAppointment(data)
        myprint(res)
        return

    def getSimpleType(self, value):
        return [{"language": "eng", "value": value}]

    def getSlot(self, record):
        if not keyExists('slotDate', record):
            myprint("Skipping appointment booking: SlotDate is empty")
            return None
        if not keyExists('slotTimeFrom', record):
            myprint("Skipping appointment booking: slotTimeFrom is empty")
            return None
        if not keyExists('slotTimeTo', record):
            myprint("Skipping appointment booking: slotTimeTo is empty")
            return None
        if not keyExists(self.input_to_idschema['registrationCenter']['final'], record):
            myprint("Skipping appointment booking: registrationCenter is empty")
            return None
        if len(record[self.input_to_idschema['registrationCenter']['final']]) == 0:
            myprint("Skipping appointment booking: registrationCenter is empty")
            return None

        return BookingSlot(record['slotDate'],
                           record['slotTimeFrom'],
                           record['slotTimeTo'],
                           record[self.input_to_idschema['registrationCenter']['final']],
                           record['arn']
                           )
