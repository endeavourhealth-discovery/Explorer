package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class QueryLibraryResult {
    private int page = 1;
    private int length = 0;
    private List<QueryLibrary> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public QueryLibraryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public QueryLibraryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<QueryLibrary> getResults() {
        return results;
    }

    public QueryLibraryResult setResults(List<QueryLibrary> results) {
        this.results = results;
        return this;
    }
}
