package io.mosip.idrepository.remap.util.config;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@ConfigurationProperties(prefix = "openapi")
@Data
public class OpenApiProperties {
    private InfoProperty info;
    private IdRepoVidServiceServer idRepoVidServiceServer;
}

@Data
class InfoProperty {
    private String title;
    private String description;
    private String version;
    private LicenseProperty license;
}

@Data
class LicenseProperty {
    private String name;
    private String url;
}

@Data
class IdRepoVidServiceServer {
    private List<Server> servers;
}

@Data
class Server {
    private String description;
    private String url;
}
