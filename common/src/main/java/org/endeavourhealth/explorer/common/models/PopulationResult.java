package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class PopulationResult {
    private int page = 1;
    private int length = 0;
    private List<Population> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public PopulationResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public PopulationResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Population> getResults() {
        return results;
    }

    public PopulationResult setResults(List<Population> results) {
        this.results = results;
        return this;
    }
}
