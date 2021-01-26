package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class CovidLibrary {
    private static final Logger LOG = LoggerFactory.getLogger(CovidLibrary.class);
    private Integer dashboardId;
    private String name;
    private String updated;
    private String type;
    private String jsonQuery;

    public String getUpdated() {
        return updated;
    }

    public CovidLibrary setUpdated(Date updated) {
        try {
            String pattern = "dd-MMM-yyyy";
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

            this.updated = simpleDateFormat.format(updated);
        }
        catch (Exception e) {
            LOG.error(e.getMessage());
        }
        return this;
    }

    public String getName() {
        return name;
    }

    public CovidLibrary setName(String name) {
        this.name = name;
        return this;
    }

    public Integer getDashboardId() {
        return dashboardId;
    }

    public CovidLibrary setDashboardId(Integer dashboardId) {
        this.dashboardId = dashboardId;
        return this;
    }

    public String getType() {
        return type;
    }

    public CovidLibrary setType(String type) {
        this.type = type;
        return this;
    }

    public String getJsonQuery() {
        return jsonQuery;
    }

    public CovidLibrary setJsonQuery(String jsonQuery) {
        this.jsonQuery = jsonQuery;
        return this;
    }


}
