package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class DashboardLibraryResult {
    private int page = 1;
    private int length = 0;
    private List<Dashboard> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public DashboardLibraryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public DashboardLibraryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Dashboard> getResults() {
        return results;
    }

    public DashboardLibraryResult setResults(List<Dashboard> results) {
        this.results = results;
        return this;
    }
}
