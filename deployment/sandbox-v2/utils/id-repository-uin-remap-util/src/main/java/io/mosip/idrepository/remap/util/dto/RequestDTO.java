package io.mosip.idrepository.remap.util.dto;

import java.util.List;

import lombok.Data;

@Data
public class RequestDTO {

	private String primaryUin;
	
	private List<String> uinsToDeactivate;
}
