package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({
        "label",
        "property",
        "secondary"
})
public class TableHeader {

    @JsonProperty("label")
    private String label;

    @JsonProperty("property")
    private String property;

    @JsonProperty("secondary")
    private boolean secondary;

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getProperty() {
        return property;
    }

    public void setProperty(String property) {
        this.property = property;
    }

    public boolean isSecondary() {
        return secondary;
    }

    public void setSecondary(boolean secondary) { this.secondary = secondary; }
}
