-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_biometric_h
-- Purpose    	: UIN Biometric History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: idrepo.uin_biometric_h | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_biometric_h CASCADE;
CREATE TABLE idrepo.uin_biometric_h(
	uin_ref_id character varying(36) NOT NULL,
	biometric_file_type character varying(36) NOT NULL,
	eff_dtimes timestamp NOT NULL,
	bio_file_id character varying(128) NOT NULL,
	biometric_file_name character varying(128) NOT NULL,
	biometric_file_hash character varying(64) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_uinbh PRIMARY KEY (uin_ref_id,biometric_file_type,eff_dtimes),
	CONSTRAINT uk_uinbh UNIQUE (uin_ref_id,bio_file_id,eff_dtimes)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_biometric_h IS 'UIN Biometric History : This to track changes to base table record whenever there is an INSERT/UPDATE/DELETE ( soft delete ), Effective DateTimestamp is used for identifying latest or point in time information. Refer base table description for details.   ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.uin_ref_id IS 'UIN Reference ID: System generated id mapped to a UIN used for references in the system. UIN reference ID is also used as folder/bucket in DFS (HDFS/CEPH) to store documents and biometric CBEFF file. refers to idrepo.uin.uin_ref_id';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.biometric_file_type IS 'Biometric File Type:  Type of the biometric file stored in DFS (HDFS/CEPPH). File type can be individual biometric file or parent /guardian biometric file.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.eff_dtimes IS 'Effective Datetimestamp : This to track base table record changes whenever there is an INSERT/UPDATE/DELETE ( soft delete ).  The current record is effective from this date-time  till next change occurs.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.bio_file_id IS 'Biometric File ID: ID of the biometric CBEFF file that is stored in filesystem storage like HDFS/CEPH. If File ID Is not available then name of the file itself can be used as file ID.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.biometric_file_name IS 'Biometric File Name: Name of the biometric CBEFF file that is stored in filesystem storage like HDFS/CEPH.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.biometric_file_hash IS 'Biometric File Hash: Hash value of the Biometric CBEFF file which is stored in DFS (HDFS/CEPH) storage. While reading the file, hash value of the file is verified with this hash value to ensure file validity.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric_h.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
