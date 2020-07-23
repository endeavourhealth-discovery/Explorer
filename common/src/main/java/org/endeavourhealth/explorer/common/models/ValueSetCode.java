package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ValueSetCode {
    private static final Logger LOG = LoggerFactory.getLogger(ValueSetCode.class);

    private String type;
    private String code;
    private String term;
    private String snomed;
    private String updated;
    private String id;


    public String getType() {
        return type;
    }

    public ValueSetCode setType(String type) {
        this.type = type;
        return this;
    }

    public String getCode() {
        return code;
    }

    public ValueSetCode setCode(String code) {
        this.code = code;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public ValueSetCode setTerm(String term) {
        this.term = term;
        return this;
    }

    public String getSnomed() {
        return snomed;
    }

    public ValueSetCode setSnomed(String snomed) {
        this.snomed = snomed;
        return this;
    }

    public String getUpdated() {
        return updated;
    }

    public ValueSetCode setUpdated(Date updated) {
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

    public String getId() {
        return id;
    }

    public ValueSetCode setId(String id) {
        this.id = id;
        return this;
    }

}
