package io.mosip.idrepository.remap.util.dto;

import java.util.List;

import lombok.Data;

/**
 * The Class BaseRequestResponseDTO - base class containing fields for Id
 * repository request and response.
 *
 * @author Manoj SP
 */
@Data
public class BaseRequestResponseDTO {

	/** The status. */
	private String status;

	/** The identity. */
	private Object identity;
	
	/** The documents. */
	
	private List<String> verifiedAttributes;
}
