package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class LookupListResult {
    private int page = 1;
    private int length = 0;
    private List<LookupList> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public LookupListResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public LookupListResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<LookupList> getResults() {
        return results;
    }

    public LookupListResult setResults(List<LookupList> results) {
        this.results = results;
        return this;
    }
}
