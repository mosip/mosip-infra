package io.mosip.idrepository.remap.util.vid.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * The Entity for Vid.
 * 
 * @author Prem Kumar
 *
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "vid", schema = "idmap")
@Entity
public class Vid {

	/** The Id value */
	@Id
	private String id;

	/** The vid value */
	private String vid;
	
	/** The uin Hash value */
	@Column(name = "uin_hash")
	private String uinHash;
	
	/** The uin value */
	private String uin;

	/** The value to hold vid Type Code */
	@Column(name = "vidtyp_code")
	private String vidTypeCode;

	/** The value to hold generated DTimes */
	@Column(name = "generated_dtimes")
	private LocalDateTime generatedDTimes;

	/** The value to hold expiry DTimes */
	@Column(name = "expiry_dtimes")
	private LocalDateTime expiryDTimes;

	/** The value to hold status Code */
	@Column(name = "status_code")
	private String statusCode;

	/** The value to hold created By */
	@Column(name = "cr_by")
	private String createdBy;

	/** The value to hold created DTimes */
	@Column(name = "cr_dtimes")
	private LocalDateTime createdDTimes;

	/** The value to hold updated By */
	@Column(name = "upd_by", nullable = true)
	private String updatedBy;

	/** The value to hold updated Time */
	@Column(name = "upd_dtimes", nullable = true)
	private LocalDateTime updatedDTimes;

	@Column(name = "is_deleted", nullable = true)
	private boolean isDeleted;

	/** The value to hold deleted DTimes */
	@Column(name = "del_dtimes", nullable = true)
	private LocalDateTime deletedDTimes;

}
