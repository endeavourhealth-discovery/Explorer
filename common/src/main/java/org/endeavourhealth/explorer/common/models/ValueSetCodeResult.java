package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class ValueSetCodeResult {
    private int page = 1;
    private int length = 0;
    private List<ValueSetCode> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public ValueSetCodeResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public ValueSetCodeResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<ValueSetCode> getResults() {
        return results;
    }

    public ValueSetCodeResult setResults(List<ValueSetCode> results) {
        this.results = results;
        return this;
    }
}
