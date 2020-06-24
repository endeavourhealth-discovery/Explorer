package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class PatientResult {
    private int page = 1;
    private int length = 0;
    private List<org.endeavourhealth.explorer.common.models.PatientSummary> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public org.endeavourhealth.explorer.common.models.PatientResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public org.endeavourhealth.explorer.common.models.PatientResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<org.endeavourhealth.explorer.common.models.PatientSummary> getResults() {
        return results;
    }

    public org.endeavourhealth.explorer.common.models.PatientResult setResults(List<org.endeavourhealth.explorer.common.models.PatientSummary> results) {
        this.results = results;
        return this;
    }
}
