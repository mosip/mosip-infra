package io.mosip.idrepository.remap.util.identity.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * The Class Uin -Entity class for uin table.
 *
 * @author Manoj SP
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "uin", schema = "idrepo")
@Entity
public class Uin {

	/** The uin ref id. */
	@Id
	@Column(insertable = false, updatable = false, nullable = false)
	private String uinRefId;

	/** The uin. */
	private String uin;

	private String uinHash;

	/** The uin data. */
	@Lob
	@Type(type = "org.hibernate.type.BinaryType")
	@Getter(AccessLevel.NONE)
	@Setter(AccessLevel.NONE)
	private byte[] uinData;

	/** The uin data hash. */
	private String uinDataHash;

	/** The reg id. */
	private String regId;

	private String bioRefId;

	/** The status code. */
	private String statusCode;
	
	private String langCode;

	/** The created by. */
	@Column(name = "cr_by")
	private String createdBy;

	/** The created date time. */
	@Column(name = "cr_dtimes")
	private LocalDateTime createdDateTime;

	/** The updated by. */
	@Column(name = "upd_by")
	private String updatedBy;

	/** The updated date time. */
	@Column(name = "upd_dtimes")
	private LocalDateTime updatedDateTime;

	/** The is deleted. */
	private Boolean isDeleted;

	/** The deleted date time. */
	@Column(name = "del_dtimes")
	private LocalDateTime deletedDateTime;

	/**
	 * Gets the uin data.
	 *
	 * @return the uin data
	 */
	public byte[] getUinData() {
		return uinData.clone();
	}

	/**
	 * Sets the uin data.
	 *
	 * @param uinData the new uin data
	 */
	public void setUinData(byte[] uinData) {
		this.uinData = uinData.clone();
	}

	public String getUin() {
		return uin;
	}

	public void setUin(String uin) {
		this.uin = uin;
	}

}
