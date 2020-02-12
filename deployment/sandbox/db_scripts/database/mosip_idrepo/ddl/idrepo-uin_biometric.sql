-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_repo
-- Table Name 	: idrepo.uin_biometric
-- Purpose    	: UIN Biometric: This table stores biometric information of an individual. The biometric information is captured in CBEFF file format. The CBEFF file is stored in separate storage like HDFS/CEPH store, only the reference to the file is maintained in this table. Along with the reference, a hash value of the biometric file is also maintained as an added security measure to prevent data tampering.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- NOTE: the code below contains the SQL for the selected object
-- as well for its dependencies and children (if applicable).
-- 
-- This feature is only a convinience in order to permit you to test
-- the whole object's SQL definition at once.
-- 
-- When exporting or generating the SQL for the whole database model
-- all objects will be placed at their original positions.


-- object: idrepo.uin_biometric | type: TABLE --
-- DROP TABLE IF EXISTS idrepo.uin_biometric CASCADE;
CREATE TABLE idrepo.uin_biometric(
	uin_ref_id character varying(36) NOT NULL,
	biometric_file_type character varying(36) NOT NULL,
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
	CONSTRAINT pk_uinb PRIMARY KEY (uin_ref_id,biometric_file_type),
	CONSTRAINT uk_uinb UNIQUE (uin_ref_id,bio_file_id)

);
-- ddl-end --
COMMENT ON TABLE idrepo.uin_biometric IS 'UIN Biometric: This table stores biometric information of an individual. The biometric information is captured in CBEFF file format. The CBEFF file is stored in separate storage like HDFS/CEPH store, only the reference to the file is maintained in this table. Along with the reference, a hash value of the biometric file is also maintained as an added security measure to prevent data tampering. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.uin_ref_id IS 'UIN Reference ID: System generated id mapped to a UIN used for references in the system. UIN reference ID is also used as folder/bucket in DFS (HDFS/CEPH) to store documents and biometric CBEFF file. refers to idrepo.uin.uin_ref_id';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.biometric_file_type IS 'Biometric File Type:  Type of the biometric file stored in DFS (HDFS/CEPPH). File type can be individual biometric file or parent /guardian biometric file.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.bio_file_id IS 'Biometric File ID: ID of the biometric CBEFF file that is stored in filesystem storage like HDFS/CEPH. If File ID Is not available then name of the file itself can be used as file ID.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.biometric_file_name IS 'Biometric File Name: Name of the biometric CBEFF file that is stored in filesystem storage like HDFS/CEPH.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.biometric_file_hash IS 'Biometric File Hash: Hash value of the Biometric CBEFF file which is stored in DFS (HDFS/CEPH) storage. While reading the file, hash value of the file is verified with this hash value to ensure file validity.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN idrepo.uin_biometric.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
