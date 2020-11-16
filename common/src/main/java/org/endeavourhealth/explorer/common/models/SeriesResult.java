package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class SeriesResult {
    private int page = 1;
    private int length = 0;
    private List<Series> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public SeriesResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public SeriesResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Series> getResults() {
        return results;
    }

    public SeriesResult setResults(List<Series> results) {
        this.results = results;
        return this;
    }
}
