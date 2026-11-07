package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.List;

public class AuditLogResult {
    private int page = 1;
    private int length = 0;
    private List<AuditLog> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public AuditLogResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getLength() {
        return length;
    }

    public AuditLogResult setLength(int length) {
        this.length = length;
        return this;
    }

    public List<AuditLog> getResults() {
        return results;
    }

    public AuditLogResult setResults(List<AuditLog> results) {
        this.results = results;
        return this;
    }
}
