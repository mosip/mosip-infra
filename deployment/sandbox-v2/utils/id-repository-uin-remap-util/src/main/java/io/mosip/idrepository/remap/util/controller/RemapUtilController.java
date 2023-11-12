package io.mosip.idrepository.remap.util.controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import io.mosip.idrepository.remap.util.dto.RequestDTO;
import io.mosip.idrepository.remap.util.service.RemapUtilService;
import io.mosip.kernel.core.exception.BaseCheckedException;
import io.mosip.kernel.core.exception.ServiceError;
import io.mosip.kernel.core.http.ResponseWrapper;

@RestController
public class RemapUtilController {
	
	@Autowired
	private RemapUtilService service;

	@PostMapping(path = "/remap", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ResponseWrapper<Map<String, Object>>> remap(@RequestBody RequestDTO request)
			throws BaseCheckedException {
		ResponseWrapper<Map<String, Object>> responseWrapper = new ResponseWrapper<>();
		try {
			Objects.requireNonNull(request);
			Objects.requireNonNull(request.getPrimaryUin());
			Objects.requireNonNull(request.getUinsToDeactivate());
			Map<String, List<String>> remapResponse = service.remap(request.getPrimaryUin(), request.getUinsToDeactivate());
			responseWrapper.setResponse(Map.of("status", "Remapping success", "metadata", remapResponse));
			return ResponseEntity.ok(responseWrapper);
		} catch (Exception e) {
			responseWrapper.setResponse(Map.of("status", "Remapping failed"));
			responseWrapper.setErrors(List.of(new ServiceError("", e.getMessage())));
			return ResponseEntity.badRequest().body(responseWrapper);
		}
	}
}
