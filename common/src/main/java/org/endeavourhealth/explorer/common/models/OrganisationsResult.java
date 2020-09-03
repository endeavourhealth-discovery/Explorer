package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class OrganisationsResult {
    private int page = 1;
    private int length = 0;
    private List<Organisations> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public OrganisationsResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public OrganisationsResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Organisations> getResults() {
        return results;
    }

    public OrganisationsResult setResults(List<Organisations> results) {
        this.results = results;
        return this;
    }
}
