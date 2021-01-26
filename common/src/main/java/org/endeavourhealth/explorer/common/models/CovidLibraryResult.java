package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class CovidLibraryResult {
    private int page = 1;
    private int length = 0;
    private List<CovidLibrary> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public CovidLibraryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public CovidLibraryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<CovidLibrary> getResults() {
        return results;
    }

    public CovidLibraryResult setResults(List<CovidLibrary> results) {
        this.results = results;
        return this;
    }
}
