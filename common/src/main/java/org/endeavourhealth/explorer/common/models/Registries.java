package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Registries {
    private static final Logger LOG = LoggerFactory.getLogger(Registries.class);

    private String ccg;
    private Integer listSize;
    private String allColumns;

    public String getCcg() {
        return ccg;
    }

    public Registries setCcg(String ccg) {
        this.ccg = ccg;
        return this;
    }

    public Integer getListSize() {
        return listSize;
    }

    public Registries setListSize(Integer listSize) {
        this.listSize = listSize;
        return this;
    }

    public String getAllColumns() {
        return allColumns;
    }

    public Registries setAllColumns(String allColumns) {
        this.allColumns = allColumns;
        return this;
    }



}
