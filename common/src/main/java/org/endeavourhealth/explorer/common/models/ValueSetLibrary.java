package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ValueSetLibrary {
    private static final Logger LOG = LoggerFactory.getLogger(ValueSetLibrary.class);
    private Integer id;
    private String name;
    private String updated;

    public String getUpdated() {
        return updated;
    }

    public ValueSetLibrary setUpdated(Date updated) {
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

    public ValueSetLibrary setName(String name) {
        this.name = name;
        return this;
    }

    public Integer getId() {
        return id;
    }

    public ValueSetLibrary setId(Integer id) {
        this.id = id;
        return this;
    }


}
