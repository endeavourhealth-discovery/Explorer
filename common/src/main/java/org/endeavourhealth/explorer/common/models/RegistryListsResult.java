package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class RegistryListsResult {
    private int page = 1;
    private int length = 0;
    private List<RegistryLists> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public RegistryListsResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public RegistryListsResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<RegistryLists> getResults() {
        return results;
    }

    public RegistryListsResult setResults(List<RegistryLists> results) {
        this.results = results;
        return this;
    }
}
