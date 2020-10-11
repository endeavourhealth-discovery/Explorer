package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Registries {
    private static final Logger LOG = LoggerFactory.getLogger(Registries.class);

    private String org;
    private Integer listSize;
    private String allColumns;
    private String registrySize;

    public String getOrg() {
        return org;
    }

    public Registries setOrg(String org) {
        this.org = org;
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

    public String getRegistrySize() {
        return registrySize;
    }

    public Registries setRegistrySize(String registrySize) {
        this.registrySize = registrySize;
        return this;
    }

}
