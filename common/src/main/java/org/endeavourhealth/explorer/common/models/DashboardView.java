package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class DashboardView {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardView.class);


    private String type;
    private String name;
    private String jsonQuery;

    public String getType() {
        return type;
    }

    public DashboardView setType(String type) {
        this.type = type;
        return this;
    }

    public String getName() {
        return name;
    }

    public DashboardView setName(String name) {
        this.name = name;
        return this;
    }

    public String getJsonQuery() {
        return jsonQuery;
    }

    public DashboardView setQuery(String jsonQuery) {
        this.jsonQuery = jsonQuery;
        return this;
    }


}
