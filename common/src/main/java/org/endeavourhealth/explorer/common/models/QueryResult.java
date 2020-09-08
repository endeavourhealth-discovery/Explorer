package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class QueryResult {
    private int page = 1;
    private int length = 0;
    private List<Query> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public QueryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public QueryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Query> getResults() {
        return results;
    }

    public QueryResult setResults(List<Query> results) {
        this.results = results;
        return this;
    }
}
