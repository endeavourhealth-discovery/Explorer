package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class LookupList {
    private static final Logger LOG = LoggerFactory.getLogger(LookupList.class);

    private String type;

    public String getType() {
        return type;
    }

    public LookupList setType(String type) {
        this.type = type;
        return this;
    }

}
