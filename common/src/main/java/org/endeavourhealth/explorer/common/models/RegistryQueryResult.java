package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class RegistryQueryResult {
    private int page = 1;
    private int length = 0;
    private List<RegistryQuery> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public RegistryQueryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public RegistryQueryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<RegistryQuery> getResults() {
        return results;
    }

    public RegistryQueryResult setResults(List<RegistryQuery> results) {
        this.results = results;
        return this;
    }
}
