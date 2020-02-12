-- -------------------------------------------------------------------------------------------------
-- Database Name: mosip_ida
-- Table Name 	: ida.auth_transaction
-- Purpose    	: Authentication Transaction : To track all authentication transactions steps / stages in the process flow.
--           
-- Create By   	: Nasir Khan / Sadanandegowda
-- Created Date	: 15-Jul-2019
-- 
-- Modified Date        Modified By         Comments / Remarks
-- ------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------

-- object: ida.auth_transaction | type: TABLE --
-- DROP TABLE IF EXISTS ida.auth_transaction CASCADE;
CREATE TABLE ida.auth_transaction(
	id character varying(36) NOT NULL,
	request_dtimes timestamp NOT NULL,
	response_dtimes timestamp NOT NULL,
	request_trn_id character varying(64),
	auth_type_code character varying(36) NOT NULL,
	status_code character varying(36) NOT NULL,
	status_comment character varying(1024),
	lang_code character varying(3) NOT NULL,
	ref_id_type character varying(36),
	ref_id character varying(64),
	uin character varying(500),
	uin_hash character varying(128),
	requested_entity_type character varying(64),
	requested_entity_id character varying(36),
	requested_entity_name character varying(128),
	static_tkn_id character varying(64),
	cr_by character varying(256) NOT NULL,
	cr_dtimes timestamp NOT NULL,
	upd_by character varying(256),
	upd_dtimes timestamp,
	is_deleted boolean,
	del_dtimes timestamp,
	CONSTRAINT pk_authtrn_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE ida.auth_transaction IS 'Authentication Transaction : To track all authentication transactions steps / stages in the process flow.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.id IS 'ID: This is unique transaction id assigned for each authentication transaction';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.request_dtimes IS 'Request Datetimestamp : Timestamp of Authentication request received from client system.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.response_dtimes IS 'Response Datetimestamp : Date timestamp of response sent back to client system for the authentication request. ';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.request_trn_id IS 'Request Transaction Id : Unique Authentication request transaction id assigned for each request received from client system.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.auth_type_code IS 'Authentication Type Code : Type of authentication for the specific transaction, for ex.,  OTP, BIO, DEMO, etc';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.status_code IS 'Status Code : Current Status code of the transaction in a process flow.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.status_comment IS 'Status Comment : Description for the status entered/updated by user or system assigned for the specific transaction.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.lang_code IS 'Language Code : For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.ref_id_type IS 'Reference Id Type: Type of reference id entered in reference id column for ex., USER, VIRTUALID, UIN, PREREG, etc.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.ref_id IS 'Reference Id: Reference ID for any cross reference purpose relevant for tracking, for ex., user id, uin, vid, prereg id, rid etc.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.uin IS 'UIN: UIN of an individual which is validated by system after the authentication is successful. The authentication can be done using UIN or VID or any other ids that are associated to an UIN. The UIN stored here is encrypted. This field is mainly used to get the list of authentication requests of an individual.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.uin_hash IS 'UIN Hash: Hash value of the UIN which was authenticated, this will have value if the UIN is a valid UIN. The authentication can be done using UIN or VID or any other ids that are associated to an UIN. The UIN stored here is hashed. This field is mainly used to get the list of authentication requests of an individual.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.requested_entity_type IS 'Requested Entity Type: Type of entity through which the authentication request was initiated. It can from a partner, internal authenticaition, etc.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.requested_entity_id IS 'Requested Entity Id: ID of the entity through which the authentication request was initiated.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.requested_entity_name IS 'Requested Entity Name: Name of the entity through which the authentication request was initiated.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.static_tkn_id IS 'Static Token Id : This is a static token id assigned for each authentication request. Static token id is combination of TSPID + UIN generated for any TSP or Individuls and sent back in response. End user can use this id while authenticating themselves. ';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.cr_by IS 'Created By : ID or name of the user who create / insert record';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.cr_dtimes IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.upd_by IS 'Updated By : ID or name of the user who update the record with new values';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.upd_dtimes IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.is_deleted IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';
-- ddl-end --
COMMENT ON COLUMN ida.auth_transaction.del_dtimes IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';
-- ddl-end --
