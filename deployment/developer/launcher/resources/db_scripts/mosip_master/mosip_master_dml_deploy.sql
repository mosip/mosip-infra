\c mosip_master sysadmin

\set CSVDataPath '\'/home/dbadmin/mosip_master/dml'

-------------- Level 1 data load scripts ------------------------

----- TRUNCATE master.app_detail TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.app_detail cascade ;

\COPY master.app_detail (id,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-app_detail.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.authentication_method TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.authentication_method cascade ;

\COPY master.authentication_method (code,method_seq,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-authentication_method.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.biometric_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.biometric_type cascade ;

\COPY master.biometric_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-biometric_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.blacklisted_words TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.blacklisted_words cascade ;

\COPY master.blacklisted_words (word,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-blacklisted_words.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.device_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.device_type cascade ;

\COPY master.device_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-device_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.doc_category TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.doc_category cascade ;

\COPY master.doc_category (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-doc_category.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.doc_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.doc_type cascade ;

\COPY master.doc_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-doc_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.gender TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.gender cascade ;

\COPY master.gender (code,name,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-gender.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.id_type TABLE Data and It's reference Data and COPY Data from CSV file ----- 
TRUNCATE TABLE master.id_type cascade ;

\COPY master.id_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-id_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.language TABLE Data and It's reference Data and COPY Data from CSV file ----- 
TRUNCATE TABLE master.language cascade ;

\COPY master.language (code,name,family,native_name,is_active,cr_by,cr_dtimes) FROM './dml/master-language.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.location TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.location cascade ;

\COPY master.location (code,name,hierarchy_level,hierarchy_level_name,parent_loc_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-location.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.machine_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.machine_type cascade ;

\COPY master.machine_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-machine_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.module_detail TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.module_detail cascade ;

\COPY master.module_detail (id,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-module_detail.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.process_list TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.process_list cascade ;

\COPY master.process_list (id,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-process_list.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reason_category TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reason_category cascade ;

\COPY master.reason_category (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reason_category.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_type cascade ;

\COPY master.reg_center_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.role_list TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.role_list cascade ;

\COPY master.role_list (code,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-role_list.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.status_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.status_type cascade ;

\COPY master.status_type (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-status_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.template_file_format TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.template_file_format cascade ;

\COPY master.template_file_format (code,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-template_file_format.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.template_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.template_type cascade ;

\COPY master.template_type (code,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-template_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.title TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.title cascade ;

\COPY master.title (code,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-title.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.individual_type TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.individual_type cascade ;

\COPY master.individual_type (code,name,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-individual_type.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.zone TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.zone cascade ;

\COPY master.zone (code,name,hierarchy_level,hierarchy_level_name,hierarchy_path,parent_zone_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-zone.csv' delimiter ',' HEADER  csv;

-------------- Level 2 data load scripts ------------------------

----- TRUNCATE master.app_authentication_method TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.app_authentication_method cascade ;

\COPY master.app_authentication_method (app_id,process_id,role_code,auth_method_code,method_seq,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-app_authentication_method.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.app_role_priority TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.app_role_priority cascade ;

\COPY master.app_role_priority (app_id,process_id,role_code,priority,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-app_role_priority.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.biometric_attribute TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.biometric_attribute cascade ;

\COPY master.biometric_attribute (code,name,descr,bmtyp_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-biometric_attribute.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.device_spec TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.device_spec cascade ;

\COPY master.device_spec (id,name,brand,model,dtyp_code,min_driver_ver,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-device_spec.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.loc_holiday TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.loc_holiday cascade ;

\COPY master.loc_holiday (id,location_code,holiday_date,holiday_name,holiday_desc,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-loc_holiday.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.machine_spec TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.machine_spec cascade ;

\COPY master.machine_spec (id,name,brand,model,mtyp_code,min_driver_ver,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-machine_spec.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reason_list TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reason_list cascade ;

\COPY master.reason_list (code,name,descr,rsncat_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reason_list.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.registration_center TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.registration_center cascade ;

\COPY master.registration_center (id,name,cntrtyp_code,addr_line1,addr_line2,addr_line3,latitude,longitude,location_code,contact_phone,contact_person,number_of_kiosks,working_hours,per_kiosk_process_time,center_start_time,center_end_time,lunch_start_time,lunch_end_time,time_zone,holiday_loc_code,zone_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-registration_center.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.screen_detail TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.screen_detail cascade ;

\COPY master.screen_detail (id,app_id,name,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-screen_detail.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.status_list TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.status_list cascade ;

\COPY master.status_list (code,descr,sttyp_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-status_list.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.template TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.template cascade ;

\COPY master.template (id,name,descr,file_format_code,model,file_txt,module_id,module_name,template_typ_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-template.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.applicant_valid_document TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.applicant_valid_document cascade ;

\COPY master.applicant_valid_document (apptyp_code,doccat_code,doctyp_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-applicant_valid_document.csv' delimiter ',' HEADER  csv;


----- TRUNCATE master.valid_document TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.valid_document cascade ;

\COPY master.valid_document (doctyp_code,doccat_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-valid_document.csv' delimiter ',' HEADER  csv;

-------------- Level 3 data load scripts ------------------------

----- TRUNCATE master.device_master TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.device_master cascade ;

\COPY master.device_master (id,name,mac_address,serial_num,ip_address,dspec_id,zone_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-device_master.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.machine_master TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.machine_master cascade ;

\COPY master.machine_master (id,name,mac_address,serial_num,ip_address,mspec_id,zone_code,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-machine_master.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.screen_authorization TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.screen_authorization cascade ;

\COPY master.screen_authorization (screen_id,role_code,lang_code,is_permitted,is_active,cr_by,cr_dtimes) FROM './dml/master-screen_authorization.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.user_detail TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.user_detail cascade ;

\COPY master.user_detail (id,uin,name,email,mobile,status_code,lang_code,last_login_method,is_active,cr_by,cr_dtimes) FROM './dml/master-user_detail.csv' delimiter ',' HEADER  csv;

-------------- Level 4 data load scripts ------------------------

----- TRUNCATE master.reg_center_device TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_device cascade ;

\COPY master.reg_center_device (regcntr_id,device_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_device.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_machine TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_machine cascade ;

\COPY master.reg_center_machine (regcntr_id,machine_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_machine.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_machine_device TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_machine_device cascade ;

\COPY master.reg_center_machine_device (regcntr_id,machine_id,device_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_machine_device.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_user TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_user cascade ;

\COPY master.reg_center_user (regcntr_id,usr_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_user.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_user_machine TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_user_machine cascade ;

\COPY master.reg_center_user_machine (regcntr_id,usr_id,machine_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-reg_center_user_machine.csv' delimiter ',' HEADER  csv;


----- TRUNCATE master.zone_user TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.zone_user cascade ;

\COPY master.zone_user (zone_code,usr_id,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/master-zone_user.csv' delimiter ',' HEADER  csv;

-------------- Level 5 data load scripts ------------------------

----- TRUNCATE master.device_master_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.device_master_h cascade ;

\COPY master.device_master_h (id,name,mac_address,serial_num,ip_address,dspec_id,zone_code,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-device_master_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.machine_master_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.machine_master_h cascade ;

\COPY master.machine_master_h (id,name,mac_address,serial_num,ip_address,mspec_id,zone_code,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-machine_master_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_device_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_device_h cascade ;

\COPY master.reg_center_device_h (regcntr_id,device_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-reg_center_device_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_machine_device_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_machine_device_h cascade ;

\COPY master.reg_center_machine_device_h (regcntr_id,machine_id,device_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-reg_center_machine_device_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_machine_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_machine_h cascade ;

\COPY master.reg_center_machine_h (regcntr_id,machine_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-reg_center_machine_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_user_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_user_h cascade ;

\COPY master.reg_center_user_h (regcntr_id,usr_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-reg_center_user_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.reg_center_user_machine_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.reg_center_user_machine_h cascade ;

\COPY master.reg_center_user_machine_h (regcntr_id,usr_id,machine_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-reg_center_user_machine_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.registration_center_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.registration_center_h cascade ;

\COPY master.registration_center_h (id,name,cntrtyp_code,addr_line1,addr_line2,addr_line3,latitude,longitude,location_code,contact_phone,contact_person,number_of_kiosks,working_hours,per_kiosk_process_time,center_start_time,center_end_time,lunch_start_time,lunch_end_time,time_zone,holiday_loc_code,zone_code,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-registration_center_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.user_detail_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.user_detail_h cascade ;

\COPY master.user_detail_h (id,uin,name,email,mobile,status_code,lang_code,last_login_method,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-user_detail_h.csv' delimiter ',' HEADER  csv;

----- TRUNCATE master.zone_user TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE master.zone_user_h cascade ;

\COPY master.zone_user_h (zone_code,usr_id,lang_code,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/master-zone_user_h.csv' delimiter ',' HEADER  csv;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------


















