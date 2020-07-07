package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ValueSet {
    private static final Logger LOG = LoggerFactory.getLogger(ValueSet.class);

    private String type;
    private String code;
    private String term;
    private String snomed;
    private String updated;


    public String getType() {
        return type;
    }

    public ValueSet setType(String type) {
        this.type = type;
        return this;
    }

    public String getCode() {
        return code;
    }

    public ValueSet setCode(String code) {
        this.code = code;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public ValueSet setTerm(String term) {
        this.term = term;
        return this;
    }

    public String getSnomed() {
        return snomed;
    }

    public ValueSet setSnomed(String snomed) {
        this.snomed = snomed;
        return this;
    }

    public String getUpdated() {
        return updated;
    }

    public ValueSet setUpdated(Date updated) {
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

}
