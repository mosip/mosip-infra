-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_master
-- Table Name 	: All tables at mosip_master Database
-- Purpose    	: To establish FOREIGN Constrations required for entity relationship
--       
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- Foreign Key Constraints Same DB/Schema tables.

-- FOREIGN KEY CONSTRAINTS : mosip_master database/schema.
 

-- object: fk_appauthm_appdtl | type: CONSTRAINT --
-- ALTER TABLE master.app_authentication_method DROP CONSTRAINT IF EXISTS fk_appauthm_appdtl CASCADE;
ALTER TABLE master.app_authentication_method ADD CONSTRAINT fk_appauthm_appdtl FOREIGN KEY (app_id,lang_code)
REFERENCES master.app_detail (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_appauthm_prclst | type: CONSTRAINT --
-- ALTER TABLE master.app_authentication_method DROP CONSTRAINT IF EXISTS fk_appauthm_prclst CASCADE;
ALTER TABLE master.app_authentication_method ADD CONSTRAINT fk_appauthm_prclst FOREIGN KEY (process_id,lang_code)
REFERENCES master.process_list (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_appauthm_rolelst | type: CONSTRAINT --
-- ALTER TABLE master.app_authentication_method DROP CONSTRAINT IF EXISTS fk_appauthm_rolelst CASCADE;
ALTER TABLE master.app_authentication_method ADD CONSTRAINT fk_appauthm_rolelst FOREIGN KEY (role_code,lang_code)
REFERENCES master.role_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_appauthm_authmeth | type: CONSTRAINT --
-- ALTER TABLE master.app_authentication_method DROP CONSTRAINT IF EXISTS fk_appauthm_authmeth CASCADE;
ALTER TABLE master.app_authentication_method ADD CONSTRAINT fk_appauthm_authmeth FOREIGN KEY (auth_method_code,lang_code)
REFERENCES master.authentication_method (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_roleprt_appdtl | type: CONSTRAINT --
-- ALTER TABLE master.app_role_priority DROP CONSTRAINT IF EXISTS fk_roleprt_appdtl CASCADE;
ALTER TABLE master.app_role_priority ADD CONSTRAINT fk_roleprt_appdtl FOREIGN KEY (app_id,lang_code)
REFERENCES master.app_detail (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_roleprt_prclst | type: CONSTRAINT --
-- ALTER TABLE master.app_role_priority DROP CONSTRAINT IF EXISTS fk_roleprt_prclst CASCADE;
ALTER TABLE master.app_role_priority ADD CONSTRAINT fk_roleprt_prclst FOREIGN KEY (process_id,lang_code)
REFERENCES master.process_list (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_roleprt_rolelst | type: CONSTRAINT --
-- ALTER TABLE master.app_role_priority DROP CONSTRAINT IF EXISTS fk_roleprt_rolelst CASCADE;
ALTER TABLE master.app_role_priority ADD CONSTRAINT fk_roleprt_rolelst FOREIGN KEY (role_code,lang_code)
REFERENCES master.role_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_lochol_loc | type: CONSTRAINT --
-- ALTER TABLE master.loc_holiday DROP CONSTRAINT IF EXISTS fk_lochol_loc CASCADE;
ALTER TABLE master.loc_holiday ADD CONSTRAINT fk_lochol_loc FOREIGN KEY (location_code,lang_code)
REFERENCES master.location (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_avaldoc_doctyp | type: CONSTRAINT --
-- ALTER TABLE master.applicant_valid_document DROP CONSTRAINT IF EXISTS fk_avaldoc_doctyp CASCADE;
ALTER TABLE master.applicant_valid_document ADD CONSTRAINT fk_avaldoc_doctyp FOREIGN KEY (doctyp_code,lang_code)
REFERENCES master.doc_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_avaldoc_doccat | type: CONSTRAINT --
-- ALTER TABLE master.applicant_valid_document DROP CONSTRAINT IF EXISTS fk_avaldoc_doccat CASCADE;
ALTER TABLE master.applicant_valid_document ADD CONSTRAINT fk_avaldoc_doccat FOREIGN KEY (doccat_code,lang_code)
REFERENCES master.doc_category (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_bmattr_bmtyp | type: CONSTRAINT --
-- ALTER TABLE master.biometric_attribute DROP CONSTRAINT IF EXISTS fk_bmattr_bmtyp CASCADE;
ALTER TABLE master.biometric_attribute ADD CONSTRAINT fk_bmattr_bmtyp FOREIGN KEY (bmtyp_code,lang_code)
REFERENCES master.biometric_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_devicem_dspec | type: CONSTRAINT --
-- ALTER TABLE master.device_master DROP CONSTRAINT IF EXISTS fk_devicem_dspec CASCADE;
ALTER TABLE master.device_master ADD CONSTRAINT fk_devicem_dspec FOREIGN KEY (dspec_id,lang_code)
REFERENCES master.device_spec (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_devicem_zone | type: CONSTRAINT --
-- ALTER TABLE master.device_master DROP CONSTRAINT IF EXISTS fk_devicem_zone CASCADE;
ALTER TABLE master.device_master ADD CONSTRAINT fk_devicem_zone FOREIGN KEY (zone_code,lang_code)
REFERENCES master.zone (code,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_dspec_dtyp | type: CONSTRAINT --
-- ALTER TABLE master.device_spec DROP CONSTRAINT IF EXISTS fk_dspec_dtyp CASCADE;
ALTER TABLE master.device_spec ADD CONSTRAINT fk_dspec_dtyp FOREIGN KEY (dtyp_code,lang_code)
REFERENCES master.device_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_lkeyper | type: CONSTRAINT --
-- ALTER TABLE master.licensekey_permission DROP CONSTRAINT IF EXISTS fk_lkeyper CASCADE;
ALTER TABLE master.licensekey_permission ADD CONSTRAINT fk_lkeyper FOREIGN KEY (license_key)
REFERENCES master.licensekey_list (license_key) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_machm_mspec | type: CONSTRAINT --
-- ALTER TABLE master.machine_master DROP CONSTRAINT IF EXISTS fk_machm_mspec CASCADE;
ALTER TABLE master.machine_master ADD CONSTRAINT fk_machm_mspec FOREIGN KEY (mspec_id,lang_code)
REFERENCES master.machine_spec (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_machm_zone | type: CONSTRAINT --
-- ALTER TABLE master.machine_master DROP CONSTRAINT IF EXISTS fk_machm_zone CASCADE;
ALTER TABLE master.machine_master ADD CONSTRAINT fk_machm_zone FOREIGN KEY (zone_code,lang_code)
REFERENCES master.zone (code,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_mspec_mtyp | type: CONSTRAINT --
-- ALTER TABLE master.machine_spec DROP CONSTRAINT IF EXISTS fk_mspec_mtyp CASCADE;
ALTER TABLE master.machine_spec ADD CONSTRAINT fk_mspec_mtyp FOREIGN KEY (mtyp_code,lang_code)
REFERENCES master.machine_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rsnlst_rsncat | type: CONSTRAINT --
-- ALTER TABLE master.reason_list DROP CONSTRAINT IF EXISTS fk_rsnlst_rsncat CASCADE;
ALTER TABLE master.reason_list ADD CONSTRAINT fk_rsnlst_rsncat FOREIGN KEY (rsncat_code,lang_code)
REFERENCES master.reason_category (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrdev_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_device DROP CONSTRAINT IF EXISTS fk_cntrdev_regcntr CASCADE;
ALTER TABLE master.reg_center_device ADD CONSTRAINT fk_cntrdev_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrdev_devicem | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_device DROP CONSTRAINT IF EXISTS fk_cntrdev_devicem CASCADE;
ALTER TABLE master.reg_center_device ADD CONSTRAINT fk_cntrdev_devicem FOREIGN KEY (device_id,lang_code)
REFERENCES master.device_master (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmac_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_machine DROP CONSTRAINT IF EXISTS fk_cntrmac_regcntr CASCADE;
ALTER TABLE master.reg_center_machine ADD CONSTRAINT fk_cntrmac_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmac_machm | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_machine DROP CONSTRAINT IF EXISTS fk_cntrmac_machm CASCADE;
ALTER TABLE master.reg_center_machine ADD CONSTRAINT fk_cntrmac_machm FOREIGN KEY (machine_id,lang_code)
REFERENCES master.machine_master (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmdev_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_regcntr CASCADE;
ALTER TABLE master.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmdev_machm | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_machm CASCADE;
ALTER TABLE master.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_machm FOREIGN KEY (machine_id,lang_code)
REFERENCES master.machine_master (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmdev_devicem | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_devicem CASCADE;
ALTER TABLE master.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_devicem FOREIGN KEY (device_id,lang_code)
REFERENCES master.device_master (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrusr_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_user DROP CONSTRAINT IF EXISTS fk_cntrusr_regcntr CASCADE;
ALTER TABLE master.reg_center_user ADD CONSTRAINT fk_cntrusr_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrusr_usrdtl | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_user DROP CONSTRAINT IF EXISTS fk_cntrusr_usrdtl CASCADE;
ALTER TABLE master.reg_center_user ADD CONSTRAINT fk_cntrusr_usrdtl FOREIGN KEY (usr_id)
REFERENCES master.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regcntr_cntrtyp | type: CONSTRAINT --
-- ALTER TABLE master.registration_center DROP CONSTRAINT IF EXISTS fk_regcntr_cntrtyp CASCADE;
ALTER TABLE master.registration_center ADD CONSTRAINT fk_regcntr_cntrtyp FOREIGN KEY (cntrtyp_code,lang_code)
REFERENCES master.reg_center_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regcntr_loc | type: CONSTRAINT --
-- ALTER TABLE master.registration_center DROP CONSTRAINT IF EXISTS fk_regcntr_loc CASCADE;
ALTER TABLE master.registration_center ADD CONSTRAINT fk_regcntr_loc FOREIGN KEY (location_code,lang_code)
REFERENCES master.location (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regcntr_zone | type: CONSTRAINT --
-- ALTER TABLE master.registration_center DROP CONSTRAINT IF EXISTS fk_regcntr_zone CASCADE;
ALTER TABLE master.registration_center ADD CONSTRAINT fk_regcntr_zone FOREIGN KEY (zone_code,lang_code)
REFERENCES master.zone (code,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_scrauth_scrdtl | type: CONSTRAINT --
-- ALTER TABLE master.screen_authorization DROP CONSTRAINT IF EXISTS fk_scrauth_scrdtl CASCADE;
ALTER TABLE master.screen_authorization ADD CONSTRAINT fk_scrauth_scrdtl FOREIGN KEY (screen_id,lang_code)
REFERENCES master.screen_detail (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_scrauth_rolelst | type: CONSTRAINT --
-- ALTER TABLE master.screen_authorization DROP CONSTRAINT IF EXISTS fk_scrauth_rolelst CASCADE;
ALTER TABLE master.screen_authorization ADD CONSTRAINT fk_scrauth_rolelst FOREIGN KEY (role_code,lang_code)
REFERENCES master.role_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_scrdtl_appdtl | type: CONSTRAINT --
-- ALTER TABLE master.screen_detail DROP CONSTRAINT IF EXISTS fk_scrdtl_appdtl CASCADE;
ALTER TABLE master.screen_detail ADD CONSTRAINT fk_scrdtl_appdtl FOREIGN KEY (app_id,lang_code)
REFERENCES master.app_detail (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_status_sttyp | type: CONSTRAINT --
-- ALTER TABLE master.status_list DROP CONSTRAINT IF EXISTS fk_status_sttyp CASCADE;
ALTER TABLE master.status_list ADD CONSTRAINT fk_status_sttyp FOREIGN KEY (sttyp_code,lang_code)
REFERENCES master.status_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_tmplt_tmpltyp | type: CONSTRAINT --
-- ALTER TABLE master.template DROP CONSTRAINT IF EXISTS fk_tmplt_tmpltyp CASCADE;
ALTER TABLE master.template ADD CONSTRAINT fk_tmplt_tmpltyp FOREIGN KEY (template_typ_code,lang_code)
REFERENCES master.template_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_tmplt_tffmt | type: CONSTRAINT --
-- ALTER TABLE master.template DROP CONSTRAINT IF EXISTS fk_tmplt_tffmt CASCADE;
ALTER TABLE master.template ADD CONSTRAINT fk_tmplt_tffmt FOREIGN KEY (file_format_code,lang_code)
REFERENCES master.template_file_format (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_tmplt_moddtl | type: CONSTRAINT --
-- ALTER TABLE master.template DROP CONSTRAINT IF EXISTS fk_tmplt_moddtl CASCADE;
ALTER TABLE master.template ADD CONSTRAINT fk_tmplt_moddtl FOREIGN KEY (module_id,lang_code)
REFERENCES master.module_detail (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_tsplkeym | type: CONSTRAINT --
-- ALTER TABLE master.tsp_licensekey_map DROP CONSTRAINT IF EXISTS fk_tsplkeym CASCADE;
ALTER TABLE master.tsp_licensekey_map ADD CONSTRAINT fk_tsplkeym FOREIGN KEY (license_key)
REFERENCES master.licensekey_list (license_key) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrdtl_logmeth | type: CONSTRAINT --
-- ALTER TABLE master.user_detail DROP CONSTRAINT IF EXISTS fk_usrdtl_logmeth CASCADE;
ALTER TABLE master.user_detail ADD CONSTRAINT fk_usrdtl_logmeth FOREIGN KEY (last_login_method,lang_code)
REFERENCES master.authentication_method (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrdtl_status | type: CONSTRAINT --
-- ALTER TABLE master.user_detail DROP CONSTRAINT IF EXISTS fk_usrdtl_status CASCADE;
ALTER TABLE master.user_detail ADD CONSTRAINT fk_usrdtl_status FOREIGN KEY (status_code,lang_code)
REFERENCES master.status_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrpwd_status | type: CONSTRAINT --
-- ALTER TABLE master.user_pwd DROP CONSTRAINT IF EXISTS fk_usrpwd_status CASCADE;
ALTER TABLE master.user_pwd ADD CONSTRAINT fk_usrpwd_status FOREIGN KEY (status_code,lang_code)
REFERENCES master.status_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrpwd_usrdtl | type: CONSTRAINT --
-- ALTER TABLE master.user_pwd DROP CONSTRAINT IF EXISTS fk_usrpwd_usrdtl CASCADE;
ALTER TABLE master.user_pwd ADD CONSTRAINT fk_usrpwd_usrdtl FOREIGN KEY (usr_id)
REFERENCES master.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_usrrol_rolelst | type: CONSTRAINT --
-- ALTER TABLE master.user_role DROP CONSTRAINT IF EXISTS fk_usrrol_rolelst CASCADE;
ALTER TABLE master.user_role ADD CONSTRAINT fk_usrrol_rolelst FOREIGN KEY (role_code,lang_code)
REFERENCES master.role_list (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usrrol_usrdtl | type: CONSTRAINT --
-- ALTER TABLE master.user_role DROP CONSTRAINT IF EXISTS fk_usrrol_usrdtl CASCADE;
ALTER TABLE master.user_role ADD CONSTRAINT fk_usrrol_usrdtl FOREIGN KEY (usr_id)
REFERENCES master.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_valdoc_doctyp | type: CONSTRAINT --
-- ALTER TABLE master.valid_document DROP CONSTRAINT IF EXISTS fk_valdoc_doctyp CASCADE;
ALTER TABLE master.valid_document ADD CONSTRAINT fk_valdoc_doctyp FOREIGN KEY (doctyp_code,lang_code)
REFERENCES master.doc_type (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_valdoc_doccat | type: CONSTRAINT --
-- ALTER TABLE master.valid_document DROP CONSTRAINT IF EXISTS fk_valdoc_doccat CASCADE;
ALTER TABLE master.valid_document ADD CONSTRAINT fk_valdoc_doccat FOREIGN KEY (doccat_code,lang_code)
REFERENCES master.doc_category (code,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_zoneuser_zone | type: CONSTRAINT --
-- ALTER TABLE master.zone_user DROP CONSTRAINT IF EXISTS fk_zoneuser_zone CASCADE;
ALTER TABLE master.zone_user ADD CONSTRAINT fk_zoneuser_zone FOREIGN KEY (zone_code,lang_code)
REFERENCES master.zone (code,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmusr_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_regcntr CASCADE;
ALTER TABLE master.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmusr_machm | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_machm CASCADE;
ALTER TABLE master.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_machm FOREIGN KEY (machine_id,lang_code)
REFERENCES master.machine_master (id,lang_code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cntrmusr_usrdtl | type: CONSTRAINT --
-- ALTER TABLE master.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_usrdtl CASCADE;
ALTER TABLE master.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_usrdtl FOREIGN KEY (usr_id)
REFERENCES master.user_detail (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_rdstyp_dtype_code | type: CONSTRAINT --
-- ALTER TABLE master.reg_device_sub_type DROP CONSTRAINT IF EXISTS fk_rdstyp_dtype_code CASCADE;
ALTER TABLE master.reg_device_sub_type ADD CONSTRAINT fk_rdstyp_dtype_code FOREIGN KEY (dtyp_code)
REFERENCES master.reg_device_type (code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_mds_devprd | type: CONSTRAINT --
-- ALTER TABLE master.mosip_device_service DROP CONSTRAINT IF EXISTS fk_mds_devprd CASCADE;
ALTER TABLE master.mosip_device_service ADD CONSTRAINT fk_mds_devprd FOREIGN KEY (dprovider_id)
REFERENCES master.device_provider (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_mds_dtype | type: CONSTRAINT --
-- ALTER TABLE master.mosip_device_service DROP CONSTRAINT IF EXISTS fk_mds_dtype CASCADE;
ALTER TABLE master.mosip_device_service ADD CONSTRAINT fk_mds_dtype FOREIGN KEY (dtype_code)
REFERENCES master.reg_device_type (code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_mds_dstype | type: CONSTRAINT --
-- ALTER TABLE master.mosip_device_service DROP CONSTRAINT IF EXISTS fk_mds_dstype CASCADE;
ALTER TABLE master.mosip_device_service ADD CONSTRAINT fk_mds_dstype FOREIGN KEY (dstype_code)
REFERENCES master.reg_device_sub_type (code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_regdevm_devprd | type: CONSTRAINT --
-- ALTER TABLE master.registered_device_master DROP CONSTRAINT IF EXISTS fk_regdevm_devprd CASCADE;
ALTER TABLE master.registered_device_master ADD CONSTRAINT fk_regdevm_devprd FOREIGN KEY (provider_id)
REFERENCES master.device_provider (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regdevm_dtype | type: CONSTRAINT --
-- ALTER TABLE master.registered_device_master DROP CONSTRAINT IF EXISTS fk_regdevm_dtype CASCADE;
ALTER TABLE master.registered_device_master ADD CONSTRAINT fk_regdevm_dtype FOREIGN KEY (dtype_code)
REFERENCES master.reg_device_type (code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regdevm_dstype | type: CONSTRAINT --
-- ALTER TABLE master.registered_device_master DROP CONSTRAINT IF EXISTS fk_regdevm_dstype CASCADE;
ALTER TABLE master.registered_device_master ADD CONSTRAINT fk_regdevm_dstype FOREIGN KEY (dstype_code)
REFERENCES master.reg_device_sub_type (code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



-- object: fk_rwn_daycode | type: CONSTRAINT --
-- ALTER TABLE master.reg_working_nonworking DROP CONSTRAINT IF EXISTS fk_rwn_daycode CASCADE;
ALTER TABLE master.reg_working_nonworking ADD CONSTRAINT fk_rwn_daycode FOREIGN KEY (day_code,lang_code)
REFERENCES master.daysofweek_list (code,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_rwn_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_working_nonworking DROP CONSTRAINT IF EXISTS fk_rwn_regcntr CASCADE;
ALTER TABLE master.reg_working_nonworking ADD CONSTRAINT fk_rwn_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_regeh_regcntr | type: CONSTRAINT --
-- ALTER TABLE master.reg_exceptional_holiday DROP CONSTRAINT IF EXISTS fk_regeh_regcntr CASCADE;
ALTER TABLE master.reg_exceptional_holiday ADD CONSTRAINT fk_regeh_regcntr FOREIGN KEY (regcntr_id,lang_code)
REFERENCES master.registration_center (id,lang_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --