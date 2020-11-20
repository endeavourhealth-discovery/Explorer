package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class RegistryQuery {
    private static final Logger LOG = LoggerFactory.getLogger(RegistryQuery.class);

    private String registry;
    private String query;

    public String getRegistry() {
        return registry;
    }

    public RegistryQuery setRegistry(String registry) {
        this.registry = registry;
        return this;
    }

    public String getQuery() {
        return query;
    }

    public RegistryQuery setQuery(String query) {
        this.query = query;
        return this;
    }

}
