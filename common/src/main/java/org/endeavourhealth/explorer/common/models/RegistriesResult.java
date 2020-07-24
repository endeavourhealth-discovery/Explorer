package org.endeavourhealth.explorer.common.models;

import java.rmi.registry.Registry;
import java.util.ArrayList;
import java.util.List;

public class RegistriesResult {
    private int page = 1;
    private int length = 0;
    private List<Registries> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public RegistriesResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public RegistriesResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Registries> getResults() {
        return results;
    }

    public RegistriesResult setResults(List<Registries> results) {
        this.results = results;
        return this;
    }
}
