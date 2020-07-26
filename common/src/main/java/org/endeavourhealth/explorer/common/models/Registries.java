package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Registries {
    private static final Logger LOG = LoggerFactory.getLogger(Registries.class);

    private Integer id;
    private String registry;
    private String ccg;
    private String practice;
    private String code;
    private Integer listSize;
    private Integer registrySize;
    private String updated;
    private String parentRegistry;


    public Integer getId() {
        return id;
    }

    public Registries setId(Integer id) {
        this.id = id;
        return this;
    }

    public String getRegistry() {
        return registry;
    }

    public Registries setRegistry(String registry) {
        this.registry = registry;
        return this;
    }

    public String getCcg() {
        return ccg;
    }

    public Registries setCcg(String ccg) {
        this.ccg = ccg;
        return this;
    }

    public String getPractice() {
        return practice;
    }

    public Registries setPractice(String practice) {
        this.practice = practice;
        return this;
    }

    public String getCode() {
        return code;
    }

    public Registries setCode(String code) {
        this.code = code;
        return this;
    }

    public Integer getListSize() {
        return listSize;
    }

    public Registries setListSize(Integer listSize) {
        this.listSize = listSize;
        return this;
    }

    public Integer getRegistrySize() {
        return registrySize;
    }

    public Registries setRegistrySize(Integer registrySize) {
        this.registrySize = registrySize;
        return this;
    }

    public String getUpdated() {
        return updated;
    }

    public Registries setUpdated(Date updated) {
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

    public String getParentRegistry() {
        return parentRegistry;
    }

    public Registries setParentRegistry(String parentRegistry) {
        this.parentRegistry = parentRegistry;
        return this;
    }



}
