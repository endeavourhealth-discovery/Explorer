package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class ConceptResult {
    private int page = 1;
    private int length = 0;
    private List<Concept> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public ConceptResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public ConceptResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<Concept> getResults() {
        return results;
    }

    public ConceptResult setResults(List<Concept> results) {
        this.results = results;
        return this;
    }
}
