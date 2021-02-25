package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class QueryQueueResult {
    private int page = 1;
    private int length = 0;
    private List<QueryQueue> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public QueryQueueResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public QueryQueueResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<QueryQueue> getResults() {
        return results;
    }

    public QueryQueueResult setResults(List<QueryQueue> results) {
        this.results = results;
        return this;
    }
}
