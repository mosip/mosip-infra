-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_reg
-- Table Name : 
-- Purpose    : 
--           
-- Create By   : Nasir Khan / Sadanandegowda
-- Created Date: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 16-Jul-2019          Nasir Khan          Included the simple FK script and commented script generated from pgmodeler, which is specific to postgres
-- ------------------------------------------------------------------------------------------

-- -- object: fk_machm_mspec | type: CONSTRAINT --
-- -- ALTER TABLE reg.machine_master DROP CONSTRAINT IF EXISTS fk_machm_mspec CASCADE;
-- ALTER TABLE reg.machine_master ADD CONSTRAINT fk_machm_mspec FOREIGN KEY (mspec_id,lang_code)
-- REFERENCES reg.machine_spec (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_mspec_mtyp | type: CONSTRAINT --
-- -- ALTER TABLE reg.machine_spec DROP CONSTRAINT IF EXISTS fk_mspec_mtyp CASCADE;
-- ALTER TABLE reg.machine_spec ADD CONSTRAINT fk_mspec_mtyp FOREIGN KEY (mtyp_code,lang_code)
-- REFERENCES reg.machine_type (code,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_cntrdev_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_device DROP CONSTRAINT IF EXISTS fk_cntrdev_regcntr CASCADE;
-- ALTER TABLE reg.reg_center_device ADD CONSTRAINT fk_cntrdev_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrdev_devicem | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_device DROP CONSTRAINT IF EXISTS fk_cntrdev_devicem CASCADE;
-- ALTER TABLE reg.reg_center_device ADD CONSTRAINT fk_cntrdev_devicem FOREIGN KEY (device_id,lang_code)
-- REFERENCES reg.device_master (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_cntrmac_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_machine DROP CONSTRAINT IF EXISTS fk_cntrmac_regcntr CASCADE;
-- ALTER TABLE reg.reg_center_machine ADD CONSTRAINT fk_cntrmac_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmac_machm | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_machine DROP CONSTRAINT IF EXISTS fk_cntrmac_machm CASCADE;
-- ALTER TABLE reg.reg_center_machine ADD CONSTRAINT fk_cntrmac_machm FOREIGN KEY (machine_id,lang_code)
-- REFERENCES reg.machine_master (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- 
-- -- object: fk_cntrmdev_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_regcntr CASCADE;
-- ALTER TABLE reg.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmdev_machm | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_machm CASCADE;
-- ALTER TABLE reg.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_machm FOREIGN KEY (machine_id,lang_code)
-- REFERENCES reg.machine_master (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmdev_devicem | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_machine_device DROP CONSTRAINT IF EXISTS fk_cntrmdev_devicem CASCADE;
-- ALTER TABLE reg.reg_center_machine_device ADD CONSTRAINT fk_cntrmdev_devicem FOREIGN KEY (device_id,lang_code)
-- REFERENCES reg.device_master (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrusr_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_user DROP CONSTRAINT IF EXISTS fk_cntrusr_regcntr CASCADE;
-- ALTER TABLE reg.reg_center_user ADD CONSTRAINT fk_cntrusr_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrusr_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_user DROP CONSTRAINT IF EXISTS fk_cntrusr_usrdtl CASCADE;
-- ALTER TABLE reg.reg_center_user ADD CONSTRAINT fk_cntrusr_usrdtl FOREIGN KEY (usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmusr_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_regcntr CASCADE;
-- ALTER TABLE reg.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmusr_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_usrdtl CASCADE;
-- ALTER TABLE reg.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_usrdtl FOREIGN KEY (usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_cntrmusr_machm | type: CONSTRAINT --
-- -- ALTER TABLE reg.reg_center_user_machine DROP CONSTRAINT IF EXISTS fk_cntrmusr_machm CASCADE;
-- ALTER TABLE reg.reg_center_user_machine ADD CONSTRAINT fk_cntrmusr_machm FOREIGN KEY (machine_id,lang_code)
-- REFERENCES reg.machine_master (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_reg_reg_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.registration DROP CONSTRAINT IF EXISTS fk_reg_reg_usrdtl CASCADE;
-- ALTER TABLE reg.registration ADD CONSTRAINT fk_reg_reg_usrdtl FOREIGN KEY (reg_usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_reg_regcntr | type: CONSTRAINT --
-- -- ALTER TABLE reg.registration DROP CONSTRAINT IF EXISTS fk_reg_regcntr CASCADE;
-- ALTER TABLE reg.registration ADD CONSTRAINT fk_reg_regcntr FOREIGN KEY (regcntr_id,lang_code)
-- REFERENCES reg.registration_center (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_reg_appr_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.registration DROP CONSTRAINT IF EXISTS fk_reg_appr_usrdtl CASCADE;
-- ALTER TABLE reg.registration ADD CONSTRAINT fk_reg_appr_usrdtl FOREIGN KEY (approver_usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_regtrn_reg | type: CONSTRAINT --
-- -- ALTER TABLE reg.registration_transaction DROP CONSTRAINT IF EXISTS fk_regtrn_reg CASCADE;
-- ALTER TABLE reg.registration_transaction ADD CONSTRAINT fk_regtrn_reg FOREIGN KEY (reg_id)
-- REFERENCES reg.registration (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_regtrn_trntyp | type: CONSTRAINT --
-- -- ALTER TABLE reg.registration_transaction DROP CONSTRAINT IF EXISTS fk_regtrn_trntyp CASCADE;
-- ALTER TABLE reg.registration_transaction ADD CONSTRAINT fk_regtrn_trntyp FOREIGN KEY (trn_type_code,lang_code)
-- REFERENCES reg.transaction_type (code,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_synctrl_cntrmac | type: CONSTRAINT --
-- -- ALTER TABLE reg.sync_control DROP CONSTRAINT IF EXISTS fk_synctrl_cntrmac CASCADE;
-- ALTER TABLE reg.sync_control ADD CONSTRAINT fk_synctrl_cntrmac FOREIGN KEY (machine_id,regcntr_id)
-- REFERENCES reg.reg_center_machine (machine_id,regcntr_id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_synctrl_syncjob | type: CONSTRAINT --
-- -- ALTER TABLE reg.sync_control DROP CONSTRAINT IF EXISTS fk_synctrl_syncjob CASCADE;
-- ALTER TABLE reg.sync_control ADD CONSTRAINT fk_synctrl_syncjob FOREIGN KEY (syncjob_id)
-- REFERENCES reg.sync_job_def (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_synctrl_synctrn | type: CONSTRAINT --
-- -- ALTER TABLE reg.sync_control DROP CONSTRAINT IF EXISTS fk_synctrl_synctrn CASCADE;
-- ALTER TABLE reg.sync_control ADD CONSTRAINT fk_synctrl_synctrn FOREIGN KEY (synctrn_id)
-- REFERENCES reg.sync_transaction (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_synctrn_cntrmac | type: CONSTRAINT --
-- -- ALTER TABLE reg.sync_transaction DROP CONSTRAINT IF EXISTS fk_synctrn_cntrmac CASCADE;
-- ALTER TABLE reg.sync_transaction ADD CONSTRAINT fk_synctrn_cntrmac FOREIGN KEY (machine_id,regcntr_id)
-- REFERENCES reg.reg_center_machine (machine_id,regcntr_id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_synctrn_syncjob | type: CONSTRAINT --
-- -- ALTER TABLE reg.sync_transaction DROP CONSTRAINT IF EXISTS fk_synctrn_syncjob CASCADE;
-- ALTER TABLE reg.sync_transaction ADD CONSTRAINT fk_synctrn_syncjob FOREIGN KEY (syncjob_id)
-- REFERENCES reg.sync_job_def (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_usrbio_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.user_biometric DROP CONSTRAINT IF EXISTS fk_usrbio_usrdtl CASCADE;
-- ALTER TABLE reg.user_biometric ADD CONSTRAINT fk_usrbio_usrdtl FOREIGN KEY (usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_usrpwd_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.user_pwd DROP CONSTRAINT IF EXISTS fk_usrpwd_usrdtl CASCADE;
-- ALTER TABLE reg.user_pwd ADD CONSTRAINT fk_usrpwd_usrdtl FOREIGN KEY (usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_usrrol_usrdtl | type: CONSTRAINT --
-- -- ALTER TABLE reg.user_role DROP CONSTRAINT IF EXISTS fk_usrrol_usrdtl CASCADE;
-- ALTER TABLE reg.user_role ADD CONSTRAINT fk_usrrol_usrdtl FOREIGN KEY (usr_id)
-- REFERENCES reg.user_detail (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: fk_algc_reg | type: CONSTRAINT --
-- -- ALTER TABLE reg.audit_log_control DROP CONSTRAINT IF EXISTS fk_algc_reg CASCADE;
-- ALTER TABLE reg.audit_log_control ADD CONSTRAINT fk_algc_reg FOREIGN KEY (reg_id)
-- REFERENCES reg.registration (id) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_devicem_dspec | type: CONSTRAINT --
-- -- ALTER TABLE reg.device_master DROP CONSTRAINT IF EXISTS fk_devicem_dspec CASCADE;
-- ALTER TABLE reg.device_master ADD CONSTRAINT fk_devicem_dspec FOREIGN KEY (dspec_id,lang_code)
-- REFERENCES reg.device_spec (id,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- -- object: fk_dspec_dtyp | type: CONSTRAINT --
-- -- ALTER TABLE reg.device_spec DROP CONSTRAINT IF EXISTS fk_dspec_dtyp CASCADE;
-- ALTER TABLE reg.device_spec ADD CONSTRAINT fk_dspec_dtyp FOREIGN KEY (dtyp_code,lang_code)
-- REFERENCES reg.device_type (code,lang_code) MATCH SIMPLE
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- 
-- 

-- Foreign Key Constraints Same DB/Schema tables.

-- FOREIGN KEY CONSTRAINTS : mosip_reg database/schema.

alter table reg.registration_transaction add constraint fk_regtrn_reg foreign key (reg_id) references reg.registration(id) on delete no action on update no action ;
alter table reg.registration_transaction add constraint fk_regtrn_trntyp foreign key (trn_type_code, lang_code) references reg.transaction_type(code, lang_code) on delete no action on update no action ;
alter table reg.sync_control add constraint fk_synctrl_cntrmac foreign key (machine_id, regcntr_id) references reg.reg_center_machine(machine_id, regcntr_id) on delete no action on update no action ;
alter table reg.sync_control add constraint fk_synctrl_syncjob foreign key (syncjob_id ) references reg.sync_job_def(id) on delete no action on update no action ;
alter table reg.sync_control add constraint fk_synctrl_synctrn foreign key (synctrn_id) references reg.sync_transaction(id) on delete no action on update no action ;
alter table reg.sync_transaction add constraint fk_synctrn_cntrmac foreign key (machine_id, regcntr_id) references reg.reg_center_machine(machine_id, regcntr_id) on delete no action on update no action ;
alter table reg.sync_transaction add constraint fk_synctrn_syncjob foreign key (syncjob_id ) references reg.sync_job_def(id) on delete no action on update no action ;
alter table reg.user_pwd add constraint fk_usrpwd_usrdtl foreign key (usr_id) references reg.user_detail(id) on delete no action on update no action ;
alter table reg.user_role add constraint fk_usrrol_usrdtl foreign key (usr_id) references reg.user_detail(id) on delete no action on update no action ;
alter table reg.reg_center_device add constraint fk_cntrdev_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_device add constraint fk_cntrdev_devicem foreign key (device_id, lang_code) references reg.device_master(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_machine add constraint fk_cntrmac_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_machine add constraint fk_cntrmac_machm foreign key (machine_id, lang_code) references reg.machine_master(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_user_machine add constraint fk_cntrmusr_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_user_machine add constraint fk_cntrmusr_usrdtl foreign key (usr_id) references reg.user_detail(id) on delete no action on update no action ;
alter table reg.reg_center_user_machine add constraint fk_cntrmusr_machm foreign key (machine_id, lang_code) references reg.machine_master(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_user add constraint fk_cntrusr_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_user add constraint fk_cntrusr_usrdtl foreign key (usr_id) references reg.user_detail(id) on delete no action on update no action ;

alter table reg.reg_center_machine_device add constraint fk_cntrmdev_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_machine_device add constraint fk_cntrmdev_machm foreign key (machine_id, lang_code) references reg.machine_master(id, lang_code) on delete no action on update no action ;
alter table reg.reg_center_machine_device add constraint fk_cntrmdev_devicem foreign key (device_id, lang_code) references reg.device_master(id, lang_code) on delete no action on update no action ;

alter table reg.registration add constraint fk_reg_reg_usrdtl foreign key (reg_usr_id) references reg.user_detail(id) on delete no action on update no action ;
alter table reg.registration add constraint fk_reg_regcntr foreign key (regcntr_id, lang_code) references reg.registration_center(id, lang_code) on delete no action on update no action ;
alter table reg.registration add constraint fk_reg_appr_usrdtl foreign key (approver_usr_id) references reg.user_detail(id) on delete no action on update no action ;

alter table reg.device_master add constraint fk_devicem_dspec foreign key (dspec_id, lang_code) references reg.device_spec(id, lang_code) on delete no action on update no action ;
alter table reg.device_spec add constraint fk_dspec_dtyp foreign key (dtyp_code, lang_code) references reg.device_type(code, lang_code) on delete no action on update no action ;
alter table reg.machine_master add constraint fk_machm_mspec foreign key (mspec_id, lang_code) references reg.machine_spec(id, lang_code) on delete no action on update no action ;
alter table reg.machine_spec add constraint fk_mspec_mtyp foreign key (mtyp_code, lang_code) references reg.machine_type(code, lang_code) on delete no action on update no action ;

alter table reg.user_biometric add constraint fk_usrbio_usrdtl foreign key (usr_id) references reg.user_detail(id) on delete no action on update no action ;

-- object: fk_algc_reg | type: CONSTRAINT --
-- ALTER TABLE reg.audit_log_control DROP CONSTRAINT IF EXISTS fk_algc_reg CASCADE;
ALTER TABLE reg.audit_log_control ADD CONSTRAINT fk_algc_reg FOREIGN KEY (reg_id) REFERENCES reg.registration (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
