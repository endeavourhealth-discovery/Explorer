package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class DashboardLibrary {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardLibrary.class);
    private Integer dashboardId;
    private String name;
    private String updated;
    private String type;

    public String getUpdated() {
        return updated;
    }

    public DashboardLibrary setUpdated(Date updated) {
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

    public DashboardLibrary setName(String name) {
        this.name = name;
        return this;
    }

    public Integer getDashboardId() {
        return dashboardId;
    }

    public DashboardLibrary setDashboardId(Integer dashboardId) {
        this.dashboardId = dashboardId;
        return this;
    }

    public String getType() {
        return type;
    }

    public DashboardLibrary setType(String type) {
        this.type = type;
        return this;
    }


}
