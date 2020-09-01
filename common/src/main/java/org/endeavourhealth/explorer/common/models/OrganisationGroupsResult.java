package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class OrganisationGroupsResult {
    private int page = 1;
    private int length = 0;
    private List<OrganisationGroups> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public OrganisationGroupsResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public OrganisationGroupsResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<OrganisationGroups> getResults() {
        return results;
    }

    public OrganisationGroupsResult setResults(List<OrganisationGroups> results) {
        this.results = results;
        return this;
    }
}
