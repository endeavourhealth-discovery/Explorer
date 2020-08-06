package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class QueryLibrary {
    private static final Logger LOG = LoggerFactory.getLogger(QueryLibrary.class);
    private Integer id;
    private String type;
    private String name;
    private String updated;
    private String jsonQuery;

    public String getUpdated() {
        return updated;
    }

    public QueryLibrary setUpdated(Date updated) {
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

    public String getType() {
        return type;
    }

    public QueryLibrary setType(String type) {
        this.type = type;
        return this;
    }

    public String getName() {
        return name;
    }

    public QueryLibrary setName(String name) {
        this.name = name;
        return this;
    }

    public Integer getId() {
        return id;
    }

    public QueryLibrary setId(Integer id) {
        this.id = id;
        return this;
    }

    public String getJsonQuery() {
        return jsonQuery;
    }

    public QueryLibrary setQuery(String jsonQuery) {
        this.jsonQuery = jsonQuery;
        return this;
    }


}
