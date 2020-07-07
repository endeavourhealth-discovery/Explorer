package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class ValueSetLibraryResult {
    private int page = 1;
    private int length = 0;
    private List<ValueSetLibrary> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public ValueSetLibraryResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public ValueSetLibraryResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<ValueSetLibrary> getResults() {
        return results;
    }

    public ValueSetLibraryResult setResults(List<ValueSetLibrary> results) {
        this.results = results;
        return this;
    }
}
