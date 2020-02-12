
-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_prereg
-- Table Name 	: prereg.applicant_document
-- Purpose    	: Applicant Document: Documents that are uploaded as part of pre-registration process is maintained here. The documents are stored in document repository  and only the hash value and its location details are stored.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
--
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------
-- object: prereg.applicant_document | type: TABLE --
-- DROP TABLE IF EXISTS prereg.applicant_document CASCADE;
CREATE TABLE prereg.applicant_document(
	id character varying(36) NOT NULL,
	prereg_id character varying(36) NOT NULL,
	doc_name character varying(128) NOT NULL,
	doc_cat_code character varying(36) NOT NULL,
	doc_typ_code character varying(36) NOT NULL,
	doc_file_format character varying(36) NOT NULL,
	doc_id character varying(128) NOT NULL,
	doc_hash character varying(64) NOT NULL,
	encrypted_dtimes timestamp NOT NULL,
	status_code character varying(36) NOT NULL,
	lang_code character varying(3) NOT NULL,
	cr_by character varying(256),
	cr_dtimes timestamp,
	upd_by character varying(256),
	upd_dtimes timestamp,
	CONSTRAINT pk_appldoc_prereg_id PRIMARY KEY (id)

);

-- indexes section -------------------------------------------------
create unique index idx_appldoc_prereg_id on prereg.applicant_document (prereg_id, doc_cat_code, doc_typ_code) ;

-- ddl-end --
COMMENT ON TABLE prereg.applicant_document IS 'Applicant Document: Documents that are uploaded as part of pre-registration process is maintained here. The documents are stored in document repository  and only the hash value and its location details are stored.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.id IS 'Id: Unique id generated for the documents being uploaded as part of pre-registration process.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.prereg_id IS 'Pre Registration Id: Id of the pre-registration application for which the documents are being uploaded.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_name IS 'Document Name: Name of the document that is uploaded';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_cat_code IS 'Document Category Code: Document category code under which the document is being uploaded. Refers to master.document_category.code';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_typ_code IS 'Document Type Code: Document type code under which the document is being uploaded. Refers to master.document_type.code';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_file_format IS 'Documenet File Format: Format in which the document is being uploaded. Refers to master.document_file_format.code';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_id IS 'Document Id: ID of the document being uploaded';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.doc_hash IS 'Document Hash: Hash value of the document being uploaded in document store. This will be used to make sure that nobody has tampered the document stored in a separate store. ';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.encrypted_dtimes IS 'Encrypted Data Time: Date and time when the document was encrypted before uploading it on document store. This will also be used  get the key for decrypting the data.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.status_code IS 'Status Code: Status of the document that is being uploaded.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.cr_by IS 'Created By : ID or name of the user who create / insert record.';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN prereg.applicant_document.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --




