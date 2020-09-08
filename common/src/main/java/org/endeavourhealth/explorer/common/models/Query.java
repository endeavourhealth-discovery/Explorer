package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Query {
    private static final Logger LOG = LoggerFactory.getLogger(Query.class);

    private String jsonQuery;

    public String getJsonQuery() {
        return jsonQuery;
    }

    public Query setQuery(String jsonQuery) {
        this.jsonQuery = jsonQuery;
        return this;
    }


}
