package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class QueryQueue {
    private static final Logger LOG = LoggerFactory.getLogger(QueryQueue.class);
    private String type;
    private String registryName;
    private String date;
    private String status;
    private String timeSubmit;
    private String timeFinish;
    private String timeExecute;

    public String getType() {
        return type;
    }

    public QueryQueue setType(String type) {
        this.type = type;
        return this;
    }

    public String getRegistryName() {
        return registryName;
    }

    public QueryQueue setRegistryName(String registryName) {
        this.registryName = registryName;
        return this;
    }

    public String getDate() {
        return date;
    }

    public QueryQueue setDate(Date date) {
        try {
            String pattern = "dd-MMM-yyyy";
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

            this.date = simpleDateFormat.format(date);
        }
        catch (Exception e) {
            LOG.error(e.getMessage());
        }
        return this;
    }

    public String getStatus() {
        return status;
    }

    public QueryQueue setStatus(String status) {
        this.status = status;
        return this;
    }

    public String getTimeSubmit() {
        return timeSubmit;
    }

    public QueryQueue setTimeSubmit(String timeSubmit) {
        this.timeSubmit = timeSubmit;
        return this;
    }

    public String getTimeFinish() {
        return timeFinish;
    }

    public QueryQueue setTimeFinish(String timeFinish) {
        this.timeFinish = timeFinish;
        return this;
    }

    public String getTimeExecute() {
        return timeExecute;
    }

    public QueryQueue setTimeExecute(String timeExecute) {
        this.timeExecute = timeExecute;
        return this;
    }
}
