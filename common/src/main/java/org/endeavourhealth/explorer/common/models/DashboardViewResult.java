package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class DashboardViewResult {
    private int page = 1;
    private int length = 0;
    private List<DashboardView> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public DashboardViewResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public DashboardViewResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<DashboardView> getResults() {
        return results;
    }

    public DashboardViewResult setResults(List<DashboardView> results) {
        this.results = results;
        return this;
    }
}
