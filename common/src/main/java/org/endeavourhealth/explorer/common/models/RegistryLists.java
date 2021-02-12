package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class RegistryLists {
    private static final Logger LOG = LoggerFactory.getLogger(RegistryLists.class);
    private String ccg;
    private String practiceName;
    private String registry;
    private String listSize;
    private String registrySize;
    private String target;

    public String getCcg() {
        return ccg;
    }

    public RegistryLists setCcg(String ccg) {
        this.ccg = ccg;
        return this;
    }

    public String getPracticeName() {
        return practiceName;
    }

    public RegistryLists setPracticeName(String practiceName) {
        this.practiceName = practiceName;
        return this;
    }

    public String getRegistry() {
        return registry;
    }

    public RegistryLists setRegistry(String registry) {
        this.registry = registry;
        return this;
    }

    public String getListSize() {
        return listSize;
    }

    public RegistryLists setListSize(String listSize) {
        this.listSize = listSize;
        return this;
    }

    public String getRegistrySize() {
        return registrySize;
    }

    public RegistryLists setRegistrySize(String registrySize) {
        this.registrySize = registrySize;
        return this;
    }

    public String getTarget() {
        return target;
    }

    public RegistryLists setTarget(String target) {
        this.target = target;
        return this;
    }

}
