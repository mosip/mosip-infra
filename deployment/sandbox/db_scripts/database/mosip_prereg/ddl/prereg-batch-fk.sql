-- FKs

ALTER TABLE prereg.batch_job_execution_params ADD CONSTRAINT job_exec_params_fk FOREIGN KEY (job_execution_id)
        REFERENCES prereg.batch_job_execution (job_execution_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION ;

ALTER TABLE prereg.batch_job_execution_context ADD CONSTRAINT job_exec_ctx_fk FOREIGN KEY (job_execution_id)
        REFERENCES prereg.batch_job_execution (job_execution_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE prereg.batch_job_execution ADD CONSTRAINT job_inst_exec_fk FOREIGN KEY (job_instance_id)
        REFERENCES prereg.batch_job_instance (job_instance_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE prereg.batch_step_execution ADD CONSTRAINT job_exec_step_fk FOREIGN KEY (job_execution_id)
        REFERENCES prereg.batch_job_execution (job_execution_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE prereg.batch_step_execution_context ADD CONSTRAINT step_exec_ctx_fk FOREIGN KEY (step_execution_id)
        REFERENCES prereg.batch_step_execution (step_execution_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;
		
CREATE SEQUENCE prereg.batch_step_execution_seq;
CREATE SEQUENCE prereg.batch_job_execution_seq;
CREATE SEQUENCE prereg.batch_job_seq;

-- grants to access all sequences
GRANT usage, SELECT ON ALL SEQUENCES 
   IN SCHEMA prereg
   TO prereguser;
