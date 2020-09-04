package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Organisations {
    private static final Logger LOG = LoggerFactory.getLogger(Organisations.class);

    private String type;
    private String name;
    private String code;
    private String updated;
    private String id;


    public String getType() {
        return type;
    }

    public Organisations setType(String type) {
        this.type = type;
        return this;
    }


    public String getName() { return name; }

    public Organisations setName(String name) {
        this.name = name;
        return this;
    }


    public String getCode() {
        return code;
    }

    public Organisations setCode(String code) {
        this.code = code;
        return this;
    }


    public String getUpdated() {
        return updated;
    }

    public Organisations setUpdated(Date updated) {
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

    public Organisations setId(String id) {
        this.id = id;
        return this;
    }

}