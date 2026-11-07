package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Concept {
    private static final Logger LOG = LoggerFactory.getLogger(Concept.class);

    private String originalCode;
    private String term;
    private String useCount;


    public String getOriginalCode() {
        return originalCode;
    }

    public Concept setOriginalCode(String originalCode) {
        this.originalCode = originalCode;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public Concept setTerm(String term) {
        this.term = term;
        return this;
    }

    public String getUseCount() {
        return useCount;
    }

    public Concept setUseCount(String useCount) {
        this.useCount = useCount;
        return this;
    }

}
