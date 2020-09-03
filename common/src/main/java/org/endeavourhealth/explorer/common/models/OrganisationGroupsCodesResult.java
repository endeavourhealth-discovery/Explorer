package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class OrganisationGroupsCodesResult {
    private int page = 1;
    private int length = 0;
    private List<OrganisationGroupsCodes> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public OrganisationGroupsCodesResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public OrganisationGroupsCodesResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<OrganisationGroupsCodes> getResults() {
        return results;
    }

    public OrganisationGroupsCodesResult setResults(List<OrganisationGroupsCodes> results) {
        this.results = results;
        return this;
    }
}
