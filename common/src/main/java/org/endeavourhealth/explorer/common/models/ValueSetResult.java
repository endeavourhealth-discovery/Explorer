package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class ValueSetResult {
    private int page = 1;
    private int length = 0;
    private List<ValueSet> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public ValueSetResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public ValueSetResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<ValueSet> getResults() {
        return results;
    }

    public ValueSetResult setResults(List<ValueSet> results) {
        this.results = results;
        return this;
    }
}
